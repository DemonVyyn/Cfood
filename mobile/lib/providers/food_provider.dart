
import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../services/food_service.dart';

class FoodProvider extends ChangeNotifier {
  final FoodService _service = FoodService();

  List<FoodModel> foods = [];

  bool isLoading = false;

  String searchQuery = '';
  String selectedCategory = 'Semua';

  Future<void> loadFoods() async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _service.getFoods();

      foods = data
          .map<FoodModel>(
            (item) => FoodModel.fromJson(item),
          )
          .toList();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void setCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  // Hanya tampilkan makanan yang belum kedaluwarsa
  // dan masih memiliki stok.
  List<FoodModel> get filteredFoods {
    List<FoodModel> result = foods.where((food) {
      return food.stok > 0 && !food.isExpired;
    }).toList();

    // Filter pencarian.
    final keyword = searchQuery.trim().toLowerCase();

    if (keyword.isNotEmpty) {
      result = result.where((food) {
        return food.nama.toLowerCase().contains(keyword) ||
            food.namaToko.toLowerCase().contains(keyword) ||
            food.kategori.toLowerCase().contains(keyword);
      }).toList();
    }

    // Filter berdasarkan nama toko.
    if (selectedCategory != 'Semua') {
      result = result.where((food) {
        return food.namaToko.toLowerCase().contains(
              selectedCategory.toLowerCase(),
            );
      }).toList();
    }

    return result;
  }

  // Diskon tertinggi dari makanan yang masih tersedia.
  int get highestDiscount {
    final availableFoods = foods.where((food) {
      return food.stok > 0 && !food.isExpired;
    }).toList();

    if (availableFoods.isEmpty) return 0;

    return availableFoods
        .map((food) => food.persenDiskon)
        .reduce((a, b) => a > b ? a : b);
  }

  // Total stok makanan yang masih tersedia.
  int get totalStock {
    return foods
        .where((food) => !food.isExpired && food.stok > 0)
        .fold(0, (sum, item) => sum + item.stok);
  }

  // Jumlah jenis makanan yang masih tersedia.
  int get totalProducts {
    return foods
        .where((food) => !food.isExpired && food.stok > 0)
        .length;
  }
}
