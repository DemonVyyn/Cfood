import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? position;

  String locationName =
      'Mengambil lokasi...';

  bool isLoading = false;

  StreamSubscription<Position>?
      _locationSubscription;

  Future<void> startTracking() async {
    try {
      isLoading = true;
      notifyListeners();

      bool serviceEnabled =
          await Geolocator
              .isLocationServiceEnabled();

      if (!serviceEnabled) {
        locationName =
            'GPS tidak aktif';

        isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission =
          await Geolocator
              .checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
            await Geolocator
                .requestPermission();
      }

      if (permission ==
              LocationPermission.denied ||
          permission ==
              LocationPermission
                  .deniedForever) {
        locationName =
            'Izin lokasi ditolak';

        isLoading = false;
        notifyListeners();
        return;
      }

      final currentPosition =
          await Geolocator
              .getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy:
              LocationAccuracy.high,
        ),
      );

      position = currentPosition;

      await _updateAddress(
        currentPosition,
      );

      _locationSubscription
          ?.cancel();

      _locationSubscription =
          Geolocator
              .getPositionStream(
        locationSettings:
            const LocationSettings(
          accuracy:
              LocationAccuracy.high,
          distanceFilter: 20,
        ),
      ).listen(
        (
          Position newPosition,
        ) async {
          position =
              newPosition;

          await _updateAddress(
            newPosition,
          );

          notifyListeners();
        },
      );
    } catch (e) {
      locationName =
          'Lokasi tidak tersedia';

      debugPrint(
        'LOCATION ERROR: $e',
      );
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> _updateAddress(
    Position pos,
  ) async {
    try {
      final placemarks =
          await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place =
            placemarks.first;

        locationName =
            '${place.subLocality ?? ''}, ${place.locality ?? ''}';
      }
    } catch (_) {}
  }

  Future<void> refresh() async {
    await startTracking();
  }

  void stopTracking() {
    _locationSubscription
        ?.cancel();
  }

  @override
  void dispose() {
    stopTracking();

    super.dispose();
  }
}