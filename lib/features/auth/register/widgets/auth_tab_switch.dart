import 'package:flutter/material.dart';

class AuthTabSwitch extends StatelessWidget {
  final bool isLogin;

  const AuthTabSwitch({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isLogin) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/login',
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isLogin
                      ? const Color(0xFF166534)
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                      color: isLogin
                          ? Colors.white
                          : Colors.black54,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isLogin) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/register',
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: !isLogin
                      ? const Color(0xFF166534)
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Daftar',
                    style: TextStyle(
                      color: !isLogin
                          ? Colors.white
                          : Colors.black54,
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
    );
  }
}