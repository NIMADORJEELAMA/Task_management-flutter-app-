//     import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/keyword_provider.dart';
// import '../providers/product_provider.dart';
// import 'product_detail_screen.dart';

// class ProductListScreen extends ConsumerStatefulWidget {
//   const ProductListScreen({super.key});

//   @override
//   ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends ConsumerState<ProductListScreen> {
//   String? selectedKeywordId;

//   @override
//   Widget build(BuildContext context) {
//     final keywordsAsync = ref.watch(keywordProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Products")),
//       body: Column(
//         children: [
//           // Dropdown
//           keywordsAsync.when(
//             data: (keywords) {
//               return DropdownButton<String>(
//                 value: selectedKeywordId,
//                 hint: const Text("Select keyword"),
//                 items: keywords.map((k) {
//                   return DropdownMenuItem(
//                     value: k.id,
//                     child: Text(k.keyword),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() => selectedKeywordId = value);
//                 },
//               );
//             },
//             loading: () => const CircularProgressIndicator(),
//             error: (e, _) => Text("Error: $e"),
//           ),

//           const SizedBox(height: 16),

//           // Product list
//           if (selectedKeywordId != null)
//             Expanded(
//               child: ref.watch(productListProvider(selectedKeywordId!)).when(
//                 data: (products) {
//                   return ListView.builder(
//                     itemCount: products.length,
//                     itemBuilder: (context, index) {
//                       final p = products[index];
//                       return ListTile(
//                         leading: Image.network(p.imageUrls.isNotEmpty ? p.imageUrls.first : "", width: 50, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
//                         title: Text(p.productName),
//                         subtitle: Text(p.currentPrice),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => ProductDetailScreen(productId: p.productId),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//                 loading: () => const Center(child: CircularProgressIndicator()),
//                 error: (e, _) => Center(child: Text("Error: $e")),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


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
