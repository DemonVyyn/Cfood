
import 'package:flutter/material.dart';

class AuthTabSwitch extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool>? onTabChanged;

  const AuthTabSwitch({
    super.key,
    required this.isLogin,
    this.onTabChanged,
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
                  onTabChanged?.call(true);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isLogin
                      ? const Color(0xFF166534)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    style: TextStyle(
                      color: isLogin
                          ? Colors.white
                          : Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    child: const Text('Masuk'),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isLogin) {
                  onTabChanged?.call(false);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: !isLogin
                      ? const Color(0xFF166534)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    style: TextStyle(
                      color: !isLogin
                          ? Colors.white
                          : Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    child: const Text('Daftar'),
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
