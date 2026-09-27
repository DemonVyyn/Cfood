import 'dart:io';

import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/storage/storage_service.dart';

class MerchantProductService {
  Future<List<dynamic>>
      getProducts() async {
    final token =
        await StorageService.getToken();

    final response =
        await ApiClient.dio.get(
      '/merchant/products',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
        },
      ),
    );

    return response.data['data'];
  }

  Future<dynamic> getProduct(
    int id,
  ) async {
    final token =
        await StorageService.getToken();

    final response =
        await ApiClient.dio.get(
      '/merchant/products/$id',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
        },
      ),
    );

    return response.data['data'];
  }

  Future<void> createProduct({
    required String nama,
    required String deskripsi,
    required String kategori,
    required String hargaOriginal,
    required String hargaDiskon,
    required String stok,
    required String expired,
    File? image,
  }) async {
    final token =
        await StorageService.getToken();

    final formData =
        FormData.fromMap({
      'nama': nama,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'harga_original':
          hargaOriginal,
      'harga_diskon':
          hargaDiskon,
      'stok': stok,
      'waktu_expired':
          expired,

      if (image != null)
        'foto':
            await MultipartFile
                .fromFile(
          image.path,
        ),
    });

    await ApiClient.dio.post(
      '/merchant/products',
      data: formData,
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
          'Accept':
              'application/json',
        },
      ),
    );
  }

  Future<void> updateProduct({
    required int id,
    required String nama,
    required String deskripsi,
    required String kategori,
    required String hargaOriginal,
    required String hargaDiskon,
    required String stok,
    required String expired,
    File? image,
  }) async {
    final token =
        await StorageService.getToken();

    final formData =
        FormData.fromMap({
      '_method': 'PUT',
      'nama': nama,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'harga_original':
          hargaOriginal,
      'harga_diskon':
          hargaDiskon,
      'stok': stok,
      'waktu_expired':
          expired,

      if (image != null)
        'foto':
            await MultipartFile
                .fromFile(
          image.path,
        ),
    });

    await ApiClient.dio.post(
      '/merchant/products/$id',
      data: formData,
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
          'Accept':
              'application/json',
        },
      ),
    );
  }

  Future<void> deleteProduct(
    int id,
  ) async {
    final token =
        await StorageService.getToken();

    await ApiClient.dio.delete(
      '/merchant/products/$id',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
        },
      ),
    );
  }
}