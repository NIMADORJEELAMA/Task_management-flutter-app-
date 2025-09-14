// // import 'package:flutter/material.dart';
// // import '../services/api_service.dart';

// // class ProductDetailScreen extends StatefulWidget {
// //   final String productId;
// //   const ProductDetailScreen({super.key, required this.productId});

// //   @override
// //   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// // }

// // class _ProductDetailScreenState extends State<ProductDetailScreen> {
// //   Map<String, dynamic>? product;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadProduct();
// //   }

// //   Future<void> _loadProduct() async {
// //     final data = await ApiService.fetchProduct(widget.productId);
// //     setState(() => product = data);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (product == null) {
// //       return const Scaffold(body: Center(child: CircularProgressIndicator()));
// //     }

// //     return Scaffold(
// //       appBar: AppBar(title: Text(product!['product_name'] ?? 'Product')),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             if (product!['product_image_urls'] != null && product!['product_image_urls'].isNotEmpty)
// //               Image.network(product!['product_image_urls'][0], errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100)),
// //             const SizedBox(height: 12),
// //             Text(product!['brand_name'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //             Text(product!['current_product_price'] ?? '', style: const TextStyle(fontSize: 16, color: Colors.green)),
// //             const SizedBox(height: 10),
// //             Text(product!['product_description'] ?? 'No description'),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/product.dart';

// class ProductDetailScreen extends StatelessWidget {
//   final String productId;
//   const ProductDetailScreen({super.key, required this.productId});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Product>(
//       future: ApiService.getProductById(productId),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(body: Center(child: CircularProgressIndicator()));
//         }
//         if (snapshot.hasError) {
//           return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
//         }
//         final product = snapshot.data!;
//         return Scaffold(
//           appBar: AppBar(title: Text(product.title)),
//           body: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text(product.description),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)), // Adjust field as per your model
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(product.description ?? '', style: const TextStyle(fontSize: 16)),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}