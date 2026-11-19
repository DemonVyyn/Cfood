class UserModel {
  final int id;
  final String nama;
  final String email;
  final String phone;
  final String role;
  final String? fotoProfil;
  final String? fotoProfilUrl;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.phone,
    required this.role,
    this.fotoProfil,
    this.fotoProfilUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      fotoProfil: json['foto_profil']?.toString(),
      fotoProfilUrl: json['foto_profil_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'phone': phone,
      'role': role,
      'foto_profil': fotoProfil,
      'foto_profil_url': fotoProfilUrl,
    };
  }
}
