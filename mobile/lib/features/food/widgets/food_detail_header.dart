import 'package:flutter/material.dart';

import '../../../models/food_model.dart';
import '../../../core/constants/app_constants.dart';

class FoodDetailHeader extends StatelessWidget {
  final FoodModel food;

  const FoodDetailHeader({
    super.key,
    required this.food,
  });

  String get imageUrl {
    if (food.foto.startsWith('http')) {
      return food.foto;
    }

    return '${AppConstants.imageBaseUrl}/${food.foto}';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          width: double.infinity,
          height: 320,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            height: 320,
            color: Colors.grey.shade300,
            child: const Icon(
              Icons.image,
              size: 80,
            ),
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _circleButton(
                  Icons.arrow_back,
                  () => Navigator.pop(context),
                ),

                const Spacer(),

                _circleButton(
                  Icons.share,
                  () {},
                ),

                const SizedBox(width: 12),

                _circleButton(
                  Icons.bookmark_border,
                  () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _circleButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }
}