import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

void _showInfoDialog({
  required BuildContext context,
  required IconData icon,
  required String title,
  required Widget Function(BuildContext dialogContext)
      contentBuilder,
  String actionLabel = 'Tutup',
}) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: contentBuilder(dialogContext),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              actionLabel,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _HelpItem extends StatelessWidget {
  final String question;
  final String answer;

  const _HelpItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 18 / 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _paragraph(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        height: 20 / 13,
        color: AppColors.onSurfaceVariant,
      ),
    ),
  );
}

void showHelpCenterDialog(BuildContext context) {
  _showInfoDialog(
    context: context,
    icon: Icons.support_agent_rounded,
    title: 'Pusat Bantuan',
    actionLabel: 'Mengerti',
    contentBuilder: (_) => const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HelpItem(
          question: 'Bagaimana cara memesan makanan?',
          answer:
              'Pilih makanan di beranda, buka detail produk, lalu tekan Pesan. Pesanan akan muncul di Riwayat Pesanan.',
        ),
        _HelpItem(
          question: 'Di mana kode pengambilan pesanan?',
          answer:
              'Kode pengambilan tampil pada notifikasi ketika pesanan sudah siap diambil oleh mitra.',
        ),
        _HelpItem(
          question: 'Mengapa makanan tidak muncul di beranda?',
          answer:
              'Makanan hanya ditampilkan jika masih tersedia, stok lebih dari nol, dan belum melewati waktu kedaluwarsa.',
        ),
        _HelpItem(
          question: 'Bisakah riwayat pesanan dihapus?',
          answer:
              'Ya. Pesanan yang sudah selesai dapat dihapus dari riwayat melalui tombol hapus pada kartu pesanan.',
        ),
      ],
    ),
  );
}

void showCFoodAboutDialog(BuildContext context) {
  _showInfoDialog(
    context: context,
    icon: Icons.info_outline_rounded,
    title: 'Tentang CFood',
    contentBuilder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _paragraph(
          'CFood adalah platform yang menghubungkan konsumen dengan '
          'makanan surplus yang masih layak dikonsumsi dari mitra sekitar.',
        ),
        _paragraph(
          'Dengan memesan makanan surplus, Anda membantu mengurangi '
          'limbah makanan sekaligus mendapatkan harga yang lebih hemat.',
        ),
        _paragraph(
          'Versi aplikasi: 1.0.0',
        ),
      ],
    ),
  );
}

void showTermsDialog(BuildContext context) {
  _showInfoDialog(
    context: context,
    icon: Icons.policy_outlined,
    title:
        'Syarat Ketentuan & Kebijakan Privasi',
    actionLabel: 'Mengerti',
    contentBuilder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _paragraph(
          'Dengan menggunakan CFood, Anda menyetujui penggunaan akun '
          'secara bertanggung jawab serta keakuratan data yang '
          'dimasukkan saat registrasi dan pemesanan.',
        ),
        _paragraph(
          'Pesanan yang dibuat bersifat final setelah dikonfirmasi mitra. '
          'Pembayaran tunai dilakukan langsung kepada mitra sesuai '
          'informasi pada detail pesanan.',
        ),
        _paragraph(
          'Data pribadi seperti nama, email, dan nomor HP digunakan '
          'untuk mengelola akun, memproses pesanan, dan memberikan '
          'notifikasi terkait pesanan Anda.',
        ),
        _paragraph(
          'CFood tidak membagikan data pribadi Anda kepada pihak ketiga '
          'selain mitra yang terlibat langsung dalam pesanan Anda.',
        ),
      ],
    ),
  );
}

void showRateAppDialog(BuildContext context) {
  const storeUrl =
      'https://play.google.com/store/apps/details?id=com.example.mobile';

  _showInfoDialog(
    context: context,
    icon: Icons.star_outline_rounded,
    title: 'Beri Nilai Aplikasi',
    contentBuilder: (dialogContext) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _paragraph(
          'Bantu kami meningkatkan CFood dengan memberikan penilaian '
          'dan ulasan di Play Store.',
        ),
        const SizedBox(height: 4),
        SelectableText(
          storeUrl,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.primary,
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () async {
            await Clipboard.setData(
              const ClipboardData(text: storeUrl),
            );
            if (!dialogContext.mounted) return;
            ScaffoldMessenger.of(dialogContext).showSnackBar(
              const SnackBar(
                content: Text('Tautan Play Store disalin.'),
              ),
            );
          },
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Salin Tautan'),
        ),
      ],
    ),
  );
}
