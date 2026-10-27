import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/food_provider.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({
    super.key,
  });

  @override
  State<SearchSection> createState() =>
      _SearchSectionState();
}

class _SearchSectionState
    extends State<SearchSection> {
  final controller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (value) {
                context
                    .read<FoodProvider>()
                    .setSearchQuery(
                      value,
                    );
              },
              decoration:
                  InputDecoration(
                hintText:
                    'Cari makanan, bakery, cafe...',
                prefixIcon:
                    const Icon(
                  Icons.search,
                  color: Color(
                    0xff166534,
                  ),
                ),
                filled: true,
                fillColor:
                    Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(
                  vertical: 0,
                ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  borderSide:
                      BorderSide(
                    color: Colors
                        .grey
                        .shade300,
                  ),
                ),
                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  borderSide:
                      BorderSide(
                    color: Colors
                        .grey
                        .shade300,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          _buildFilterButton(
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        _showFilterBottomSheet(
          context,
        );
      },
      child: Container(
        width: 56,
        height: 56,
        decoration:
            BoxDecoration(
          color:
              const Color(
            0xff166534,
          ),
          borderRadius:
              BorderRadius.circular(
            16,
          ),
        ),
        child: const Icon(
          Icons.tune,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top:
              Radius.circular(
            24,
          ),
        ),
      ),
      builder: (_) {
        final tokoList = <String>[
          'Semua',
          ...context
              .read<FoodProvider>()
              .foods
              .map((f) => f.namaToko)
              .where((n) => n.isNotEmpty)
              .toSet()
              .toList(),
        ];

        return Padding(
          padding:
              const EdgeInsets.all(
            20,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              const Text(
                'Filter Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: tokoList.map((category) {
                  return ChoiceChip(
                    label: Text(
                      category,
                    ),
                    selected:
                        context
                                .watch<
                                    FoodProvider>()
                                .selectedCategory ==
                            category,
                    onSelected:
                        (_) {
                      context
                          .read<
                              FoodProvider>()
                          .setCategory(
                            category,
                          );

                      Navigator.pop(
                        context,
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      },
    );
  }
}