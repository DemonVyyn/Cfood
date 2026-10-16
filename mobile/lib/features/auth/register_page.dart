import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import 'register/widgets/auth_logo.dart';
import 'register/widgets/auth_tab_switch.dart';
import 'register/widgets/auth_text_field.dart';
import 'register/widgets/auth_password_field.dart';
import 'register/widgets/auth_primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {
  String selectedRole = 'customer';

  final namaController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmController =
      TextEditingController();

  final namaTokoController =
      TextEditingController();

  final alamatController =
      TextEditingController();

  final nomorTokoController =
      TextEditingController();

  final deskripsiController =
      TextEditingController();

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
    deskripsiController.dispose();

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
                          isLogin: false,
                        ),

                        const SizedBox(
                            height: 25),

                        Container(
                          height: 50,
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFF1F1F1,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child:
                                    GestureDetector(
                                  onTap: () {
                                    setState(
                                      () {
                                        selectedRole =
                                            'customer';
                                      },
                                    );
                                  },
                                  child:
                                      Container(
                                    margin:
                                        const EdgeInsets
                                            .all(
                                      4,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: selectedRole ==
                                              'customer'
                                          ? const Color(
                                              0xFF166534)
                                          : Colors
                                              .transparent,
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                    ),
                                    child:
                                        Center(
                                      child:
                                          Text(
                                        'Customer',
                                        style:
                                            TextStyle(
                                          color: selectedRole ==
                                                  'customer'
                                              ? Colors
                                                  .white
                                              : Colors
                                                  .black54,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child:
                                    GestureDetector(
                                  onTap: () {
                                    setState(
                                      () {
                                        selectedRole =
                                            'mitra';
                                      },
                                    );
                                  },
                                  child:
                                      Container(
                                    margin:
                                        const EdgeInsets
                                            .all(
                                      4,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: selectedRole ==
                                              'mitra'
                                          ? const Color(
                                              0xFF166534)
                                          : Colors
                                              .transparent,
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                    ),
                                    child:
                                        Center(
                                      child:
                                          Text(
                                        'Mitra',
                                        style:
                                            TextStyle(
                                          color: selectedRole ==
                                                  'mitra'
                                              ? Colors
                                                  .white
                                              : Colors
                                                  .black54,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                            height: 20),

                        AuthTextField(
                          hint:
                              'Nama Lengkap',
                          icon:
                              Icons.person,
                          controller:
                              namaController,
                        ),

                        const SizedBox(
                            height: 16),

                        AuthTextField(
                          hint: 'Email',
                          icon:
                              Icons.email,
                          controller:
                              emailController,
                        ),

                        const SizedBox(
                            height: 16),

                        AuthTextField(
                          hint:
                              'Nomor HP',
                          icon:
                              Icons.phone,
                          controller:
                              phoneController,
                        ),

                        if (selectedRole ==
                            'mitra') ...[
                          const SizedBox(
                              height: 16),

                          AuthTextField(
                            hint:
                                'Nama Toko',
                            icon: Icons
                                .store,
                            controller:
                                namaTokoController,
                          ),

                          const SizedBox(
                              height: 16),

                          AuthTextField(
                            hint:
                                'Alamat Toko',
                            icon: Icons
                                .location_on,
                            controller:
                                alamatController,
                          ),

                          const SizedBox(
                              height: 16),

                          AuthTextField(
                            hint:
                                'Nomor Telepon Toko',
                            icon: Icons
                                .phone_in_talk,
                            controller:
                                nomorTokoController,
                          ),

                          const SizedBox(
                              height: 16),

                          AuthTextField(
                            hint:
                                'Deskripsi Toko',
                            icon: Icons
                                .description,
                            controller:
                                deskripsiController,
                          ),
                        ],

                        const SizedBox(
                            height: 16),

                        AuthPasswordField(
                          hint:
                              'Password',
                          controller:
                              passwordController,
                        ),

                        const SizedBox(
                            height: 16),

                        AuthPasswordField(
                          hint:
                              'Konfirmasi Password',
                          controller:
                              confirmController,
                        ),

                        const SizedBox(
                            height: 20),

                        AuthPrimaryButton(
                          text: auth
                                  .isLoading
                              ? 'Loading...'
                              : selectedRole ==
                                      'customer'
                                  ? 'Daftar Customer'
                                  : 'Daftar Mitra',
                          onPressed: auth
                                  .isLoading
                              ? () {}
                              : () async {
                                  final navigator =
                                      Navigator.of(
                                          context);

                                  final messenger =
                                      ScaffoldMessenger.of(
                                          context);

                                  if (passwordController
                                          .text !=
                                      confirmController
                                          .text) {
                                    messenger
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text(
                                          'Konfirmasi password tidak cocok',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final success =
                                      await auth
                                          .register(
                                    role:
                                        selectedRole,
                                    nama:
                                        namaController
                                            .text
                                            .trim(),
                                    email:
                                        emailController
                                            .text
                                            .trim(),
                                    phone:
                                        phoneController
                                            .text
                                            .trim(),
                                    password:
                                        passwordController
                                            .text
                                            .trim(),
                                    namaToko:
                                        namaTokoController
                                            .text
                                            .trim(),
                                    alamat:
                                        alamatController
                                            .text
                                            .trim(),
                                    nomorTeleponToko:
                                        nomorTokoController
                                            .text
                                            .trim(),
                                    deskripsiToko:
                                        deskripsiController
                                            .text
                                            .trim(),
                                  );

                                  if (!mounted) {
                                      return;
                                  }

                                  if (success) {
                                    messenger
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text(
                                          'Registrasi berhasil',
                                        ),
                                      ),
                                    );

                                    navigator
                                        .pushReplacementNamed(
                                      '/login',
                                    );
                                  } else {
                                    messenger
                                        .showSnackBar(
                                      SnackBar(
                                        content:
                                            Text(
                                          auth.errorMessage ??
                                              'Registrasi gagal',
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