import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../providers/profile_photo_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/auth_provider.dart';

/// Kartu ringkasan profil: avatar, nama, email (dari sesi login).
class ProfileHeader extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileHeader({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil data user dari sesi yang sedang login.
    final user = context.watch<AuthProvider>().user;
    final nama = user?.nama.trim() ?? '';
    final email = user?.email.trim() ?? '';
    final photo = context.watch<ProfilePhotoProvider>().photo;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppColors.outlineVariant.withValues(alpha: 0.30),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  AppColors.primaryContainer.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar + badge pena (ketuk untuk ganti foto)
            Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.outlineVariant
                          .withValues(alpha: 0.30),
                    ),
                  ),
                  child: ClipOval(
                    child: _buildAvatar(photo),
                  ),
                ),

                // Badge ikon pena di pojok kanan bawah
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.ctaGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surfaceContainerLowest,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 12,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // Nama + kontak
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama.isNotEmpty ? nama : 'Pengguna CFood',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      height: 24 / 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    // Backend belum punya field nomor HP user;
                    // ganti baris ini dengan data user saat API siap.
                    'Nomor HP belum ditambahkan',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 16 / 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    email.isNotEmpty ? email : 'email@cfood.id',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 16 / 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Indikator bisa diketuk
            const Icon(
              Icons.chevron_right,
              size: 22,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  /// Tampilan avatar: foto terpilih (jika ada) atau foto default.
  Widget _buildAvatar(XFile? photo) {
    final picked = photo;

    if (picked == null) {
      // Foto default (Unsplash: mengirim header CORS, aman di web)
      return Image.network(
        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=150&h=150&fit=crop&crop=faces',
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: AppColors.surfaceContainerHigh,
          child: const Icon(
            Icons.person,
            size: 32,
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
        if (snapshot.connectionState == ConnectionState.done &&
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
}
