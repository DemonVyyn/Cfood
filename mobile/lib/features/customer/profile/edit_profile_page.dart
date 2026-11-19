import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';

/// Halaman "Edit Profil" (desain Stitch: Mealio Eco Surplus).
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController.text = user?.nama.trim() ?? '';
    _emailController.text = user?.email.trim() ?? '';
    _phoneController.text = user?.phone.trim() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    FocusScope.of(context).unfocus();

    setState(() => _isSaving = true);

    final success = await auth.updateProfile(
      nama: _nameController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      phone: _phoneController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ?? 'Gagal memperbarui profil.',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profil berhasil diperbarui',
          style: GoogleFonts.plusJakartaSans(),
        ),
        backgroundColor: AppColors.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SafeArea(
        child: Column(
          children: [
            // Header: tombol back + judul
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  // Tombol kembali
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.04),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Edit Profil',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      height: 28 / 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Konten scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    16, 16, 16, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors
                              .surfaceContainerLowest,
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.outlineVariant
                                .withValues(alpha: 0.30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors
                                  .primaryContainer
                                  .withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                            BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: 0.04),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildField(
                              label: 'Nama Lengkap',
                              controller: _nameController,
                              hint: 'Masukkan nama lengkap',
                              icon: Icons.person,
                              validator: (v) => v
                                      .toString()
                                      .trim()
                                      .isEmpty
                                  ? 'Nama tidak boleh kosong'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            _buildField(
                              label: 'Email',
                              controller: _emailController,
                              hint: 'nama@email.com',
                              icon: Icons.email,
                              keyboardType:
                                  TextInputType.emailAddress,
                              validator: (v) {
                                final val = v
                                    .toString()
                                    .trim();
                                if (val.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!val.contains('@')) {
                                  return 'Email tidak valid';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildField(
                              label: 'No. HP',
                              controller: _phoneController,
                              hint: '08xxxxxxxxxx',
                              icon: Icons.phone,
                              keyboardType:
                                  TextInputType.phone,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tombol simpan
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.ctaGreen,
                            disabledBackgroundColor:
                                AppColors.surfaceContainerHighest,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12),
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
                                  'Simpan',
                                  style: GoogleFonts
                                      .plusJakartaSans(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 20 / 14,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.outline,
            ),
            prefixIcon: Icon(
              icon,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.4),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.error,
              ),
            ),
          ),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
