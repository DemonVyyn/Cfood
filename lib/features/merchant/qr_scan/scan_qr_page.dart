import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../../providers/merchant_order_provider.dart';
import 'widgets/scan_overlay.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  static const Color primaryGreen = Color(0xFF166534);
  static const Color backgroundColor = Color(0xFFFAF9F7);
  static const Color textColor = Color(0xFF263126);

  final MobileScannerController _scannerController =
      MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _isProcessing = false;
  bool _isDisposed = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing || !mounted || _isDisposed) return;

    String? code;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();

      if (value != null && value.isNotEmpty) {
        code = value;
        break;
      }
    }

    if (code == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      await _scannerController.stop();

      if (!mounted) return;

      await _confirmPickup(code);
    } catch (e) {
      if (mounted) {
        await _showResultDialog(
          success: false,
          title: 'Gagal Memproses QR',
          message: 'Kamera atau proses scan mengalami kendala. '
              'Silakan coba kembali.',
        );
      }
    } finally {
      if (mounted && !_isDisposed) {
        setState(() {
          _isProcessing = false;
        });

        try {
          await _scannerController.start();
        } catch (_) {
          // Kamera mungkin sudah tidak tersedia atau halaman ditutup.
        }
      }
    }
  }

  Future<void> _confirmPickup(String code) async {
    bool success = false;
    String title = 'Pickup Gagal';
    String message = 'Kode QR tidak dapat dikonfirmasi.';

    try {
      final provider = context.read<MerchantOrderProvider>();
      final result = await provider.confirmPickup(code);

      success = result['success'] == true;
      title = success ? 'Pickup Berhasil' : 'Pickup Gagal';
      message = result['message']?.toString() ??
          (success
              ? 'Pesanan berhasil dikonfirmasi telah diambil.'
              : 'Pesanan tidak dapat dikonfirmasi.');
    } catch (e) {
      message = _extractErrorMessage(e);
    }

    if (!mounted) return;

    await _showResultDialog(
      success: success,
      title: title,
      message: message,
    );
  }

  String _extractErrorMessage(Object error) {
    final text = error.toString();

    if (text.startsWith('Exception: ')) {
      return text.substring('Exception: '.length);
    }

    return text;
  }

  Future<void> _showResultDialog({
    required bool success,
    required String title,
    required String message,
  }) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: Icon(
            success
                ? Icons.check_circle_rounded
                : Icons.error_outline_rounded,
            color: success ? primaryGreen : Colors.red.shade600,
            size: 52,
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size(140, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Scan Lagi'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: primaryGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Scan QR Pickup',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Arahkan kamera ke QR Code pickup pelanggan '
                'untuk memvalidasi dan mengonfirmasi pesanan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MobileScanner(
                        controller: _scannerController,
                        onDetect: _onDetect,
                        errorBuilder: (context, error) {
                          return Container(
                            color: Colors.black87,
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.no_photography_outlined,
                                  size: 48,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Kamera tidak dapat diakses',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  error.errorCode.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Periksa izin kamera pada perangkat.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const ScanOverlay(),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: ValueListenableBuilder(
                          valueListenable: _scannerController,
                          builder: (context, state, child) {
                            return IconButton(
                              onPressed: () {
                                _scannerController.toggleTorch();
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black54,
                                foregroundColor: Colors.white,
                              ),
                              icon: Icon(
                                state.torchState == TorchState.on
                                    ? Icons.flash_on_rounded
                                    : Icons.flash_off_rounded,
                              ),
                              tooltip: 'Nyalakan atau matikan flash',
                            );
                          },
                        ),
                      ),
                      if (_isProcessing)
                        Container(
                          color: Colors.black45,
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Memvalidasi kode pickup...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: primaryGreen,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pickup hanya berhasil jika kode valid, '
                        'pesanan milik toko ini, dan statusnya '
                        'siap diambil.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}