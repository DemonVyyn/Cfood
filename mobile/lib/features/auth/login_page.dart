import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import 'login/widgets/auth_logo.dart';
import 'login/widgets/auth_tab_switch.dart';
import 'login/widgets/auth_text_field.dart';
import 'login/widgets/auth_password_field.dart';
import 'login/widgets/auth_primary_button.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth =
        context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AuthLogo(),

                const SizedBox(height: 30),

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),
                    child: Column(
                      children: [
                        const AuthTabSwitch(
                          isLogin: true,
                        ),

                        const SizedBox(
                            height: 25),

                        const Align(
                          alignment:
                              Alignment
                                  .centerLeft,
                          child: Text(
                            'Selamat Datang Kembali',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),

                        const SizedBox(
                            height: 10),

                        AuthTextField(
                          hint:
                              'nama@email.com',
                          icon: Icons.email,
                          controller:
                              emailController,
                        ),

                        const SizedBox(
                            height: 16),

                        AuthPasswordField(
                          hint:
                              'Password',
                          controller:
                              passwordController,
                        ),

                        const SizedBox(
                            height: 20),

                        AuthPrimaryButton(
  text: auth.isLoading
      ? 'Loading...'
      : 'Masuk',
  onPressed: auth.isLoading
      ? () {}
      : () async {
          final navigator =
              Navigator.of(context);

          final messenger =
              ScaffoldMessenger.of(
            context,
          );

          final success =
              await auth.login(
            email:
                emailController.text
                    .trim(),
            password:
                passwordController
                    .text
                    .trim(),
          );

          if (!mounted) return;

          if (success) {
            if (auth.user?.role ==
                'mitra') {
              navigator
                  .pushNamedAndRemoveUntil(
                '/merchant',
                (route) => false,
              );
            } else {
              navigator
                  .pushNamedAndRemoveUntil(
                '/home',
                (route) => false,
              );
            }
          } else {
            messenger.showSnackBar(
              const SnackBar(
                content: Text(
                  'Login gagal',
                ),
              ),
            );
          }
        },
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