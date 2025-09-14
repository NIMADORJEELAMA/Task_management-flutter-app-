 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final productsAsync = ref.watch(productsProvider);
    final productsAsync = ref.watch(productsProvider(selectedKeywordId));

    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: productsAsync.when(
  data: (products) => ListView.builder(
    shrinkWrap: true,
    itemCount: products.length,
    itemBuilder: (context, index) {
      final product = products[index];
      return ListTile(
        title: Text(product.name),
        subtitle: Text(product.description),
      );
    },
  ),
  loading: () => const CircularProgressIndicator(),
  error: (e, _) => Text('Error: $e'),
)
    );
  }
}
