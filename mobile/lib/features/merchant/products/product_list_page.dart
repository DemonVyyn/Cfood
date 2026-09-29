import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/merchant_product_provider.dart';

import 'widgets/product_card.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  bool loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!loaded) {
      loaded = true;

      Future.microtask(() {
        context.read<MerchantProductProvider>().loadProducts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MerchantProductProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Produk Saya')),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Produk"),
        onPressed: () {
          Navigator.pushNamed(context, '/merchant-add-product');
        },
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];

                return ProductCard(
                  id: product.id,
                  photo: product.photo,
                  name: product.name,
                  stock: product.stock,
                  price: product.discountPrice,
                  status: product.status,
                );
              },
            ),
    );
  }
}
