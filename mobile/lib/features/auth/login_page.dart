
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'login/widgets/auth_logo.dart';
import 'login/widgets/auth_tab_switch.dart';
import 'login/widgets/auth_text_field.dart';
import 'login/widgets/auth_password_field.dart';
import 'login/widgets/auth_primary_button.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<bool>? onSwitchTab;

  const LoginPage({
    super.key,
    this.onSwitchTab,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final auth = context.read<AuthProvider>();

    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan password wajib diisi'),
        ),
      );
      return;
    }

    final success = await auth.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      if (auth.user?.role == 'mitra') {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/merchant',
          (route) => false,
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login gagal'),
        ),
      );
    }
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
                          isLogin: true,
                          onTabChanged: widget.onSwitchTab,
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          'Selamat Datang Kembali',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263126),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AuthTextField(
                          hint: 'nama@gmail.com',
                          icon: Icons.email,
                          controller: emailController,
                        ),
                        const SizedBox(height: 16),
                        AuthPasswordField(
                          hint: 'Password',
                          controller: passwordController,
                        ),
                        const SizedBox(height: 20),
                        AuthPrimaryButton(
                          text: auth.isLoading ? 'Loading...' : 'Masuk',
                          onPressed:
                              auth.isLoading ? () {} : _handleLogin,
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
