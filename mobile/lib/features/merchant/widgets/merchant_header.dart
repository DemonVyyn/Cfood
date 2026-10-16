import 'package:flutter/material.dart';

import '../dialogs/merchant_info_dialog.dart';

class MerchantHeader extends StatelessWidget {
  final String storeName;
  final String location;
  final int notificationCount;

  const MerchantHeader({
    super.key,
    required this.storeName,
    required this.location,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(
        16,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: const Icon(
              Icons.store,
              color: Colors.white,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'MITRA CFood',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  storeName,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.red,
                    ),

                    const SizedBox(
                      width: 4,
                    ),

                    Expanded(
                      child: Text(
                        location.isEmpty
                            ? 'Mengambil lokasi...'
                            : location,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            const TextStyle(
                          color:
                              Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/merchant-notifications',
                  );
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                ),
              ),

              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    constraints:
                        const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    padding:
                        const EdgeInsets.all(
                      2,
                    ),
                    decoration:
                        const BoxDecoration(
                      color: Colors.red,
                      shape:
                          BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        notificationCount >
                                99
                            ? '99+'
                            : notificationCount
                                .toString(),
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 9,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) =>
                    const MerchantInfoDialog(),
              );
            },
            icon: const Icon(
              Icons.info_outline,
            ),
          ),
        ],
      ),
    );
  }
}