import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../services/food_service.dart';

class FoodProvider
    extends ChangeNotifier {
  final FoodService _service =
      FoodService();

  List<FoodModel> foods = [];

  bool isLoading = false;

  Future<void> loadFoods() async {
    try {
      isLoading = true;

      notifyListeners();

      final data =
          await _service.getFoods();

      foods =
          data
              .map<FoodModel>(
                (item) =>
                    FoodModel
                        .fromJson(
                  item,
                ),
              )
              .toList();

      notifyListeners();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}