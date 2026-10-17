import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../services/food_service.dart';

class FoodProvider extends ChangeNotifier {
  final FoodService _service =
      FoodService();

  List<FoodModel> foods = [];

  bool isLoading = false;

  String searchQuery = '';
  String selectedCategory = 'Semua';

  Future<void> loadFoods() async {
    try {
      isLoading = true;
      notifyListeners();

      final data =
          await _service.getFoods();

      foods = data
          .map<FoodModel>(
            (item) =>
                FoodModel.fromJson(
              item,
            ),
          )
          .toList();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(
    String value,
  ) {
    searchQuery = value;
    notifyListeners();
  }

  void setCategory(
    String value,
  ) {
    selectedCategory = value;
    notifyListeners();
  }

  List<FoodModel> get filteredFoods {
    List<FoodModel> result =
        List.from(foods);

    if (searchQuery.isNotEmpty) {
      final keyword =
          searchQuery.toLowerCase();

      result = result.where((food) {
        return food.nama
                .toLowerCase()
                .contains(keyword) ||
            food.namaToko
                .toLowerCase()
                .contains(keyword) ||
            food.deskripsi
                .toLowerCase()
                .contains(keyword);
      }).toList();
    }

    if (selectedCategory !=
        'Semua') {
      result = result.where((food) {
        return food.kategori
            .toLowerCase()
            .contains(
              selectedCategory
                  .toLowerCase(),
            );
      }).toList();
    }

    return result;
  }

  int get highestDiscount {
    if (foods.isEmpty) return 0;

    return foods
        .map(
          (e) => e.persenDiskon,
        )
        .reduce(
          (a, b) =>
              a > b ? a : b,
        );
  }

  int get totalStock {
    return foods.fold(
      0,
      (sum, item) =>
          sum + item.stok,
    );
  }

  int get totalProducts {
    return foods.length;
  }
}