import 'package:flutter/material.dart';

class AuthPasswordField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;

  const AuthPasswordField({
    super.key,
    required this.hint,
    required this.controller,
  });

  @override
  State<AuthPasswordField> createState() =>
      _AuthPasswordFieldState();
}

class _AuthPasswordFieldState
    extends State<AuthPasswordField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon:
            const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscure = !obscure;
            });
          },
          icon: Icon(
            obscure
                ? Icons.visibility_off
                : Icons.visibility,
          ),
        ),
        hintText: widget.hint,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }
}