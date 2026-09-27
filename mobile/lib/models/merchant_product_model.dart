import 'package:intl/intl.dart';

class MerchantProductModel {
  final int id;

  final String name;

  final String description;

  final String kategori;

  final String? photo;

  final double originalPrice;

  final double discountPrice;

  final int stock;

  final String status;

  final String expiredAt;

  final String expiredFormatted;

  MerchantProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.kategori,
    required this.photo,
    required this.originalPrice,
    required this.discountPrice,
    required this.stock,
    required this.status,
    required this.expiredAt,
    required this.expiredFormatted,
  });

  factory MerchantProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final expiredAt =
        json['waktu_expired'] ?? '';

    String formattedDate;

    try {
      formattedDate = json[
              'expired_formatted'] ??
          DateFormat(
            'dd MMM yyyy',
            'id_ID',
          ).format(
            DateTime.parse(
              expiredAt,
            ),
          );
    } catch (e) {
      formattedDate = expiredAt;
    }

    return MerchantProductModel(
      id: json['id'] ?? 0,

      name: json['nama'] ?? '',

      description:
          json['deskripsi'] ?? '',

      kategori:
          json['kategori'] ?? '',

      photo: json['foto'],

      originalPrice:
          double.tryParse(
                json['harga_original']
                    .toString(),
              ) ??
              0,

      discountPrice:
          double.tryParse(
                json['harga_diskon']
                    .toString(),
              ) ??
              0,

      stock:
          int.tryParse(
                json['stok']
                    .toString(),
              ) ??
              0,

      status:
          json['status'] ?? 'aktif',

      expiredAt: expiredAt,

      expiredFormatted:
          formattedDate,
    );
  }
}