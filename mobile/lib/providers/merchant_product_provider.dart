import 'dart:io';

import 'package:flutter/material.dart';

import '../models/merchant_product_model.dart';
import '../services/merchant_product_service.dart';

class MerchantProductProvider
    extends ChangeNotifier {
  final MerchantProductService
      _service =
      MerchantProductService();

  List<MerchantProductModel>
      products = [];

  MerchantProductModel?
      selectedProduct;

  bool isLoading = false;

  String? error;

  Future<void> loadProducts()
      async {
    try {
      isLoading = true;

      notifyListeners();

      final result =
          await _service.getProducts();

      products =
          result
              .map(
                (e) =>
                    MerchantProductModel
                        .fromJson(e),
              )
              .toList();

      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<MerchantProductModel?>
      getProduct(
    int id,
  ) async {
    try {
      isLoading = true;

      notifyListeners();

      final result =
          await _service.getProduct(
        id,
      );

      selectedProduct =
          MerchantProductModel
              .fromJson(
        result,
      );

      return selectedProduct;
    } catch (e) {
      error = e.toString();

      return null;
    } finally {
      isLoading = false;

      notifyListeners();
    }
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
    try {
      isLoading = true;

      notifyListeners();

      await _service.createProduct(
        nama: nama,
        deskripsi: deskripsi,
        kategori: kategori,
        hargaOriginal:
            hargaOriginal,
        hargaDiskon:
            hargaDiskon,
        stok: stok,
        expired: expired,
        image: image,
      );

      await loadProducts();
    } catch (e) {
      error = e.toString();

      notifyListeners();

      rethrow;
    } finally {
      isLoading = false;

      notifyListeners();
    }
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
    try {
      isLoading = true;

      notifyListeners();

      await _service.updateProduct(
        id: id,
        nama: nama,
        deskripsi: deskripsi,
        kategori: kategori,
        hargaOriginal:
            hargaOriginal,
        hargaDiskon:
            hargaDiskon,
        stok: stok,
        expired: expired,
        image: image,
      );

      await loadProducts();
    } catch (e) {
      error = e.toString();

      notifyListeners();

      rethrow;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> deleteProduct(
    int id,
  ) async {
    try {
      await _service.deleteProduct(
        id,
      );

      products.removeWhere(
        (e) => e.id == id,
      );

      notifyListeners();
    } catch (e) {
      error = e.toString();

      notifyListeners();

      rethrow;
    }
  }

  void clearSelectedProduct() {
    selectedProduct = null;

    notifyListeners();
  }
}