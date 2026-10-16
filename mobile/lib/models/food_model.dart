class FoodModel {
  final int id;
  final String nama;
  final String deskripsi;
  final String foto;

  final double hargaOriginal;
  final double hargaDiskon;

  final int stok;

  final String namaToko;

  FoodModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.foto,
    required this.hargaOriginal,
    required this.hargaDiskon,
    required this.stok,
    required this.namaToko,
  });

  factory FoodModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FoodModel(
      id: json['id'],

      nama: json['nama'] ?? '',

      deskripsi:
          json['deskripsi'] ?? '',

      foto: json['foto'] ?? '',

      hargaOriginal:
          double.parse(
        json['harga_original']
            .toString(),
      ),

      hargaDiskon:
          double.parse(
        json['harga_diskon']
            .toString(),
      ),

      stok: json['stok'] ?? 0,

      namaToko:
          json['mitra']
                  ?['nama_toko'] ??
              '',
    );
  }
}