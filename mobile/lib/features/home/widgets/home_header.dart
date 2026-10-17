import 'dart:typed_data';
import 'package:provider/provider.dart';
import '../../../providers/profile_photo_provider.dart';
import 'package:image_picker/image_picker.dart';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil nama lengkap user dari sesi yang sedang login.
    final photo = 
        context.watch<ProfilePhotoProvider>().photo;
    final nama =
        context.watch<AuthProvider>().user?.nama.trim() ?? '';
    final displayName =
        nama.isNotEmpty ? nama : '';

    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Top app bar: pickup location
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                // Location chip
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    size: 20,
                    color: AppColors.primaryContainer,
                  ),
                ),

                const SizedBox(width: 8),

                // Location label
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Lokasi Pengambilan',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            height: 1.4,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const Icon(
                          Icons.expand_more,
                          size: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ],
                    ),
                    Text(
                      'Kepulauan Riau, Batam',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 1.33,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // User greeting & mission header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, $displayName! 🌿',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          height: 28 / 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ada 18 makanan surplus siap diselamatkan hari ini.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          height: 20 / 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Avatar with online indicator
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.secondaryContainer,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(2),
                      // Unsplash dipakai karena mengirim header CORS
                      // (i.pravatar.cc diblokir browser di Flutter Web).
                      // Icon di bawah jadi fallback kalau gambar gagal load.
                    child: _buildHomeAvatar(photo),

                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
    /// Avatar home: foto pilihan user (kalau ada) atau foto default.
  Widget _buildHomeAvatar(XFile? photo) {
    if (photo == null) {
      return const CircleAvatar(
        backgroundColor: AppColors.surfaceContainerHigh,
        backgroundImage: NetworkImage(
          'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=150&h=150&fit=crop&crop=faces',
        ),
      );
    }
    // readAsBytes + MemoryImage bekerja di web & Android.
    return FutureBuilder<Uint8List>(
      future: photo.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return CircleAvatar(
            backgroundColor: AppColors.surfaceContainerHigh,
            backgroundImage: MemoryImage(snapshot.data!),
          );
        }
        return const CircleAvatar(
          backgroundColor: AppColors.surfaceContainerHigh,
        );
      },
    );
  }
}
