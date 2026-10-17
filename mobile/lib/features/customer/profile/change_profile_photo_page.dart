import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';

/// Halaman ganti foto profil: pilih dari galeri / kamera,
/// lihat preview, lalu simpan.
class ChangeProfilePhotoPage extends StatefulWidget {
  /// Foto yang sedang dipakai (kalau ada).
  final XFile? currentPhoto;

  const ChangeProfilePhotoPage({
    super.key,
    this.currentPhoto,
  });

  @override
  State<ChangeProfilePhotoPage> createState() =>
      _ChangeProfilePhotoPageState();
}

class _ChangeProfilePhotoPageState
    extends State<ChangeProfilePhotoPage> {
  final ImagePicker _picker = ImagePicker();

  XFile? _picked;
  bool _isSaving = false;

  /// Ambil foto dari galeri atau kamera.
  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (file != null) {
        setState(() => _picked = file);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengambil foto: $e',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _save() async {
    if (_picked == null) return;

    setState(() => _isSaving = true);

    // Simulasi proses simpan (upload ke backend menyusul).
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Foto profil berhasil diperbarui',
          style: GoogleFonts.plusJakartaSans(),
        ),
        backgroundColor: AppColors.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    // Kembalikan foto terpilih ke halaman profil.
    Navigator.pop(context, _picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.onSurface,
          ),
        ),
        title: Text(
          'Ganti Foto Profil',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            height: 24 / 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Preview foto (lingkaran besar)
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.outlineVariant
                            .withValues(alpha: 0.30),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryContainer
                              .withValues(alpha: 0.10),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _buildPreview(),
                    ),
                  ),

                  // Badge pena di pojok kanan bawah
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.ctaGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surface,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                _picked != null
                    ? 'Foto siap disimpan'
                    : 'Belum ada foto dipilih',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Format JPG atau PNG, ukuran maksimal 2 MB',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  height: 16 / 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 28),

              // Tombol pilih sumber foto
              Row(
                children: [
                  Expanded(
                    child: _sourceButton(
                      icon: Icons.photo_library,
                      label: 'Dari Galeri',
                      onTap: () =>
                          _pickImage(ImageSource.gallery),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _sourceButton(
                      icon: Icons.photo_camera,
                      label: 'Dari Kamera',
                      onTap: () =>
                          _pickImage(ImageSource.camera),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Petunjuk
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.outlineVariant
                        .withValues(alpha: 0.30),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.outline,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Foto profil membantu mitra mengenali kamu saat mengambil pesanan di outlet.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          height: 16 / 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Tombol simpan
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: (_picked == null || _isSaving)
                      ? null
                      : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ctaGreen,
                    disabledBackgroundColor:
                        AppColors.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : Text(
                          'Simpan Foto',
                          style:
                              GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- PREVIEW ----------

  Widget _buildPreview() {
    final picked = _picked ?? widget.currentPhoto;

    if (picked == null) {
      // Belum ada foto: tampilkan foto default (Unsplash, aman CORS)
      return Image.network(
        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=300&h=300&fit=crop&crop=faces',
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: AppColors.surfaceContainerHigh,
          child: const Icon(
            Icons.person,
            size: 64,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }

    // readAsBytes + Image.memory bekerja di web & mobile
    // (tanpa perlu dart:io yang tidak tersedia di web).
    return FutureBuilder<Uint8List>(
      future: picked.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
                ConnectionState.done &&
            snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        }
        return Container(
          color: AppColors.surfaceContainerHigh,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  // ---------- TOMBOL SUMBER ----------

  Widget _sourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(
          color:
              AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
