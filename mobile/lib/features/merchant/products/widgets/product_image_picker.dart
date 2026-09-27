import 'dart:io';

import 'package:flutter/material.dart';

class ProductImagePicker
    extends StatelessWidget {
  final File? image;

  final VoidCallback onTap;

  const ProductImagePicker({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          border: Border.all(
            color:
                Colors.green.shade200,
          ),
        ),
        child: image == null
            ? Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 60,
                    color:
                        Colors.green.shade400,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Tambah Foto Produk",
                  ),
                ],
              )
            : ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                child: Image.file(
                  image!,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}