import 'package:flutter/material.dart';

class FoodGallery extends StatelessWidget {
  final String image;

  const FoodGallery({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          image,
          height: 280,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon:
                        const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon:
                        const Icon(Icons.share),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}