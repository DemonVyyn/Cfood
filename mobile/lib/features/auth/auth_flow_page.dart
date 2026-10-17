
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'register_page.dart';

class AuthFlowPage extends StatefulWidget {
  final bool initialIsLogin;

  const AuthFlowPage({
    super.key,
    this.initialIsLogin = true,
  });

  @override
  State<AuthFlowPage> createState() => _AuthFlowPageState();
}

class _AuthFlowPageState extends State<AuthFlowPage> {
  late bool isLogin;

  @override
  void initState() {
    super.initState();
    isLogin = widget.initialIsLogin;
  }

  void switchTab(bool showLogin) {
    if (isLogin == showLogin) return;

    setState(() {
      isLogin = showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            ignoring: !isLogin,
            child: AnimatedOpacity(
              opacity: isLogin ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: AnimatedSlide(
                offset: isLogin
                    ? Offset.zero
                    : const Offset(-0.04, 0),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: LoginPage(
                  onSwitchTab: switchTab,
                ),
              ),
            ),
          ),
          IgnorePointer(
            ignoring: isLogin,
            child: AnimatedOpacity(
              opacity: isLogin ? 0 : 1,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: AnimatedSlide(
                offset: isLogin
                    ? const Offset(0.04, 0)
                    : Offset.zero,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: RegisterPage(
                  onSwitchTab: switchTab,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
