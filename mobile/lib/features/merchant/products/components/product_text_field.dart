import 'package:flutter/material.dart';

class ProductTextField
    extends StatelessWidget {
  final String label;

  final TextEditingController
      controller;

  final int maxLines;

  const ProductTextField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 14,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration:
            InputDecoration(
          labelText: label,
          filled: true,
          fillColor:
              Colors.grey.shade50,
          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
      ),
    );
  }
}