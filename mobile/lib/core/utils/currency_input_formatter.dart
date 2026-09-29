import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter
    extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final cleanText =
        newValue.text.replaceAll(
      '.',
      '',
    );

    final value =
        int.tryParse(cleanText);

    if (value == null) {
      return oldValue;
    }

    final formatted =
        NumberFormat(
      '#,###',
      'id_ID',
    ).format(value).replaceAll(
          ',',
          '.',
        );

    return TextEditingValue(
      text: formatted,
      selection:
          TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}