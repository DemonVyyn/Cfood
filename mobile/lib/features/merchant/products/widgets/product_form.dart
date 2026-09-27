import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductForm extends StatelessWidget {
  final TextEditingController nama;
  final TextEditingController deskripsi;
  final TextEditingController kategori;
  final TextEditingController hargaAsli;
  final TextEditingController hargaDiskon;
  final TextEditingController stok;
  final TextEditingController expired;

  final VoidCallback? onSelectDate;

  const ProductForm({
    super.key,
    required this.nama,
    required this.deskripsi,
    required this.kategori,
    required this.hargaAsli,
    required this.hargaDiskon,
    required this.stok,
    required this.expired,
    this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nama,
          decoration: const InputDecoration(
            labelText: 'Nama Produk',
          ),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: kategori,
          decoration: const InputDecoration(
            labelText: 'Kategori',
          ),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: hargaAsli,
          keyboardType:
              TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter
                .digitsOnly,
          ],
          decoration: const InputDecoration(
            labelText: 'Harga Asli',
          ),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: hargaDiskon,
          keyboardType:
              TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter
                .digitsOnly,
          ],
          decoration: const InputDecoration(
            labelText:
                'Harga Diskon',
          ),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: stok,
          keyboardType:
              TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter
                .digitsOnly,
          ],
          decoration: const InputDecoration(
            labelText: 'Stok',
          ),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: expired,
          readOnly: true,
          onTap: onSelectDate,
          decoration: const InputDecoration(
            labelText:
                'Tanggal Expired',
            suffixIcon: Icon(
              Icons.calendar_month,
            ),
          ),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: deskripsi,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Deskripsi',
          ),
        ),
      ],
    );
  }
}