class FoodModel {
  final int id;
  final String nama;
  final String deskripsi;
  final String foto;

  final double hargaOriginal;
  final double hargaDiskon;

  final int stok;

  final String namaToko;
  final String kategori;

  final bool isExpired;
  final String expiredDate;

  FoodModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.foto,
    required this.hargaOriginal,
    required this.hargaDiskon,
    required this.stok,
    required this.namaToko,
    required this.kategori,
    required this.isExpired,
    required this.expiredDate,
  });

  int get persenDiskon {
    if (hargaOriginal <= 0) return 0;

    return (((hargaOriginal - hargaDiskon) /
                hargaOriginal) *
            100)
        .round();
  }

  factory FoodModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FoodModel(
      id: json['id'] ?? 0,

      nama: json['nama'] ?? '',

      deskripsi:
          json['deskripsi'] ?? '',

      foto: json['foto'] ?? '',

      hargaOriginal:
          double.tryParse(
                json['harga_original']
                    .toString(),
              ) ??
              0,

      hargaDiskon:
          double.tryParse(
                json['harga_diskon']
                    .toString(),
              ) ??
              0,

      stok:
          int.tryParse(
                json['stok']?.toString() ??
                    '0',
              ) ??
              0,

      kategori:
          json['kategori'] ??
              'Lainnya',

      namaToko:
          json['mitra']
                  ?['nama_toko'] ??
              '',

      isExpired:
          json['is_expired'] ??
              false,

      expiredDate:
          json['expired_formatted'] ??
              '',
    );
  }
}