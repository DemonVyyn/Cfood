class MerchantProfileModel {
  final int id;
  final String storeName;
  final String description;
  final String address;
  final String phone;
  final String statusVerification;

  MerchantProfileModel({
    required this.id,
    required this.storeName,
    required this.description,
    required this.address,
    required this.phone,
    required this.statusVerification,
  });

  factory MerchantProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MerchantProfileModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      storeName: json['store_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      statusVerification:
          json['status_verification']?.toString() ?? '',
    );
  }
}
