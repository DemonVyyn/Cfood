
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'register/widgets/auth_logo.dart';
import 'register/widgets/auth_tab_switch.dart';
import 'register/widgets/auth_text_field.dart';
import 'register/widgets/auth_password_field.dart';
import 'register/widgets/auth_primary_button.dart';

class RegisterPage extends StatefulWidget {
  final ValueChanged<bool>? onSwitchTab;

  const RegisterPage({
    super.key,
    this.onSwitchTab,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedRole = 'customer';

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final namaTokoController = TextEditingController();
  final alamatController = TextEditingController();
  final nomorTokoController = TextEditingController();
  final deskripsiTokoController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    namaTokoController.dispose();
    alamatController.dispose();
    nomorTokoController.dispose();
    deskripsiTokoController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final auth = context.read<AuthProvider>();

    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi password tidak sesuai'),
        ),
      );
      return;
    }

    if (namaController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi semua data yang wajib diisi'),
        ),
      );
      return;
    }

    final success = await auth.register(
      role: selectedRole,
      nama: namaController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      namaToko: namaTokoController.text.trim(),
      alamat: alamatController.text.trim(),
      nomorTeleponToko: nomorTokoController.text.trim(),
      deskripsiToko: deskripsiTokoController.text.trim(),
    );

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    if (success) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil. Silakan masuk.'),
        ),
      );

      widget.onSwitchTab?.call(true);
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ?? 'Registrasi gagal',
          ),
        ),
      );
    }
  }

  Widget _buildRoleOption({
    required String role,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final selected = selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRole = role;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFE8F8EB)
                : Colors.white,
            border: Border.all(
              color: selected
                  ? const Color(0xFF166534)
                  : const Color(0xFFE0E0E0),
              width: selected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: selected
                    ? const Color(0xFF166534)
                    : Colors.black54,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? const Color(0xFF166534)
                      : const Color(0xFF263126),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const AuthLogo(),
                const SizedBox(height: 30),
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTabSwitch(
                          isLogin: false,
                          onTabChanged: widget.onSwitchTab,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Buat Akun Baru',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263126),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pilih jenis akun yang ingin kamu daftarkan.',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 18),

                        Row(
                          children: [
                            _buildRoleOption(
                              role: 'customer',
                              title: 'Customer',
                              description: 'Beli makanan',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(width: 12),
                            _buildRoleOption(
                              role: 'mitra',
                              title: 'Mitra',
                              description: 'Jual makanan',
                              icon: Icons.storefront_outlined,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        AuthTextField(
                          hint: 'Nama lengkap',
                          icon: Icons.person_outline,
                          controller: namaController,
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          hint: 'nama@email.com',
                          icon: Icons.email_outlined,
                          controller: emailController,
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          hint: 'Nomor telepon',
                          icon: Icons.phone_outlined,
                          controller: phoneController,
                        ),
                        const SizedBox(height: 14),
                        AuthPasswordField(
                          hint: 'Password',
                          controller: passwordController,
                        ),
                        const SizedBox(height: 14),
                        AuthPasswordField(
                          hint: 'Konfirmasi password',
                          controller: confirmController,
                        ),

                        if (selectedRole == 'mitra') ...[
                          const SizedBox(height: 22),
                          const Divider(),
                          const SizedBox(height: 12),
                          const Text(
                            'Informasi Toko',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263126),
                            ),
                          ),
                          const SizedBox(height: 14),
                          AuthTextField(
                            hint: 'Nama toko',
                            icon: Icons.store_outlined,
                            controller: namaTokoController,
                          ),
                          const SizedBox(height: 14),
                          AuthTextField(
                            hint: 'Alamat toko',
                            icon: Icons.location_on_outlined,
                            controller: alamatController,
                          ),
                          const SizedBox(height: 14),
                          AuthTextField(
                            hint: 'Nomor telepon toko',
                            icon: Icons.phone_outlined,
                            controller: nomorTokoController,
                          ),
                          const SizedBox(height: 14),
                          AuthTextField(
                            hint: 'Deskripsi toko',
                            icon: Icons.description_outlined,
                            controller: deskripsiTokoController,
                          ),
                        ],

                        const SizedBox(height: 24),
                        AuthPrimaryButton(
                          text: auth.isLoading
                              ? 'Loading...'
                              : 'Daftar',
                          onPressed: auth.isLoading
                              ? () {}
                              : _handleRegister,
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
    );
  }
}
