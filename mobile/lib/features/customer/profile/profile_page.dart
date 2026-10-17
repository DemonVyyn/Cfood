import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/profile_photo_provider.dart';
import '../../customer/order_history/order_history_page.dart';
import 'change_profile_photo_page.dart';
import 'edit_profile_page.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_group.dart';

/// Halaman "Profil Saya" (desain Stitch: Mealio Eco Surplus).
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /// Buka halaman ganti foto profil (hasilnya disimpan di
  /// ProfilePhotoProvider supaya avatar di home ikut berubah).
  Future<void> _changePhoto() async {
    final photoProvider = context.read<ProfilePhotoProvider>();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeProfilePhotoPage(
          currentPhoto: photoProvider.photo,
        ),
      ),
    );

    if (result is XFile) {
      await photoProvider.setPhoto(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SafeArea(
        child: Column(
          children: [
            // Header: judul + aksi edit & pengaturan
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profil Saya',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      height: 28 / 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Row(
                    children: [
                      _headerAction(
                        icon: Icons.edit,
                        tooltip: 'Edit Profil',
                        onTap: () => _openEditProfile(context),
                      ),
                      const SizedBox(width: 4),
                      _headerAction(
                        icon: Icons.settings,
                        tooltip: 'Pengaturan',
                        onTap: () => _showComingSoon(
                          context,
                          'Pengaturan',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Konten scrollable
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  // 1. Ringkasan profil (ketuk foto → ganti foto profil)
                  ProfileHeader(
                    onTap: _changePhoto,
                  ),

                  const SizedBox(height: 16),

                  // 2. Akun & Keamanan
                  ProfileMenuGroup(
                    title: 'Akun & Keamanan',
                    items: [
                      ProfileMenuGroupItem(
                        icon: Icons.person,
                        title: 'Edit Profil',
                        subtitle: 'Nama, email, no HP',
                        onTap: () =>
                            _openEditProfile(context),
                      ),
                      ProfileMenuGroupItem(
                        icon: Icons.lock,
                        title: 'Keamanan Akun',
                        subtitle: 'Ubah Kata Sandi',
                        onTap: () => _showComingSoon(
                          context,
                          'Keamanan Akun',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 3. Preferensi & Aktivitas
                  ProfileMenuGroup(
                    title: 'Preferensi & Aktivitas',
                    items: [
                      ProfileMenuGroupItem(
                        icon: Icons.receipt_long,
                        title: 'Pesanan Saya',
                        subtitle: 'Riwayat & Pesanan Berjalan',
                        onTap: () => _openOrders(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 4. Bantuan & Informasi
                  ProfileMenuGroup(
                    title: 'Bantuan & Informasi',
                    items: const [
                      ProfileMenuGroupItem(
                        icon: Icons.support_agent,
                        iconColor: AppColors.onSurfaceVariant,
                        title: 'Pusat Bantuan & Layanan Pelanggan',
                      ),
                      ProfileMenuGroupItem(
                        icon: Icons.info,
                        iconColor: AppColors.onSurfaceVariant,
                        title: 'Tentang CFood',
                      ),
                      ProfileMenuGroupItem(
                        icon: Icons.policy,
                        iconColor: AppColors.onSurfaceVariant,
                        title: 'Syarat Ketentuan & Kebijakan Privasi',
                      ),
                      ProfileMenuGroupItem(
                        icon: Icons.star,
                        iconColor: AppColors.onSurfaceVariant,
                        title: 'Beri Nilai Aplikasi di Play Store',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 5. Tombol keluar + versi aplikasi
                  _buildLogoutButton(context),

                  const SizedBox(height: 12),

                  Text(
                    'CFood App v1.0',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      height: 16 / 11,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- AKSI HEADER ----------

  Widget _headerAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Icon(
            icon,
            size: 22,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  // ---------- TOMBOL KELUAR ----------

  Widget _buildLogoutButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _confirmLogout(context),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        side: BorderSide(
          color: AppColors.error.withValues(alpha: 0.30),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.logout,
            size: 18,
            color: AppColors.error,
          ),
          const SizedBox(width: 8),
          Text(
            'Keluar dari Akun',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(
      BuildContext context) async {
    // Ambil provider SEBELUM async gap agar tidak pakai context
    // setelah await (aman dari lint use_build_context_synchronously).
    final auth = context.read<AuthProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Keluar dari Akun',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              height: 24 / 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar dari akun CFood?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 20 / 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: Text(
                'Batal',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: Text(
                'Keluar',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await auth.logout();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  // ---------- NAVIGASI ----------

  void _openEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfilePage(),
      ),
    );
  }

  void _openOrders(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OrderHistoryPage(),
      ),
    );
  }

  void _showComingSoon(
    BuildContext context,
    String feature,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature — segera hadir',
          style: GoogleFonts.plusJakartaSans(),
        ),
        backgroundColor: AppColors.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
