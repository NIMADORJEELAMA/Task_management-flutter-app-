// import 'package:flutter/material.dart';
// import '../models/keyword.dart';
// import '../models/product.dart';
// import '../services/api_service.dart';

// class KeywordProductPage extends StatefulWidget {
//   final String? keywordId;
//   const KeywordProductPage({Key? key, this.keywordId}) : super(key: key);

//   @override
//   State<KeywordProductPage> createState() => _KeywordProductPageState();
// }

// class _KeywordProductPageState extends State<KeywordProductPage> {
//   List<Keyword> _keywords = [];
//   String? _selectedKeywordId;
//   List<Product> _products = [];
//   bool _loadingKeywords = true;
//   bool _loadingProducts = false;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _fetchKeywords();
//   }

//   Future<void> _fetchKeywords() async {
//     try {
//       final keywords = await ApiService.getKeywords();
//       setState(() {
//         _keywords = keywords;
//         _loadingKeywords = false;
//         if (keywords.isNotEmpty) {
//           _selectedKeywordId = keywords.first.id;
//           _fetchProducts(keywords.first.id);
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _loadingKeywords = false;
//       });
//     }
//   }

//   Future<void> _fetchProducts(String keywordId) async {
//     setState(() {
//       _loadingProducts = true;
//       _products = [];
//     });
//     try {
//       final products = await ApiService.getProducts(keywordId); // ✅ fixed
//       setState(() {
//         _products = products;
//         _loadingProducts = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _loadingProducts = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Keyword Product List')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (_loadingKeywords)
//               const Center(child: CircularProgressIndicator())
//             else if (_error != null)
//               Text(_error!, style: const TextStyle(color: Colors.red))
//             else
//               DropdownButtonFormField<String>(
//                 value: _selectedKeywordId,
//                 decoration: const InputDecoration(labelText: "Select Keyword"),
//                 items: _keywords
//                     .map((k) => DropdownMenuItem(
//                           value: k.id,
//                           child: Text(k.keyword),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   if (value != null) {
//                     setState(() {
//                       _selectedKeywordId = value;
//                     });
//                     _fetchProducts(value);
//                   }
//                 },
//               ),
//             const SizedBox(height: 20),
//             if (_loadingProducts)
//               const Center(child: CircularProgressIndicator())
//             else if (_products.isEmpty)
//               const Text("No products found for this keyword.")
//             else
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _products.length,
//                   itemBuilder: (context, index) {
//                     final product = _products[index];
//                     return Card(
//                       child: ListTile(
//                         leading: product.productImageUrls.isNotEmpty
//                             ? Image.network(
//                                 product.productImageUrls.first,
//                                 width: 50,
//                                 height: 50,
//                                 fit: BoxFit.cover,
//                               )
//                             : const Icon(Icons.image_not_supported),
//                         title: Text(product.productName),
//                         subtitle: Text(
//                           "${product.brandName} • ${product.currentProductPrice ?? ''}",
//                         ),
//                         onTap: () {
//                           // TODO: open product.productUrl in browser if needed
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../models/keyword.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class KeywordProductPage extends StatefulWidget {
  final String keywordId; // ✅ make required
  const KeywordProductPage({Key? key, required this.keywordId}) : super(key: key);

  @override
  State<KeywordProductPage> createState() => _KeywordProductPageState();
}

class _KeywordProductPageState extends State<KeywordProductPage> {
  List<Product> _products = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProducts(widget.keywordId);
  }

  Future<void> _fetchProducts(String keywordId) async {
    setState(() {
      _loading = true;
      _products = [];
      _error = null;
    });
    try {
      final products = await ApiService.getProducts(keywordId);
      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text("Error: $_error"))
              : _products.isEmpty
                  ? const Center(child: Text("No products found."))
                  : ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return Card(
                          child: ListTile(
                            leading: product.productImageUrls.isNotEmpty
                                ? Image.network(
                                    product.productImageUrls.first,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(product.productName),
                            subtitle: Text(
                                "${product.brandName} • ${product.currentProductPrice ?? ''}"),
                            onTap: () {
                              // TODO: open in browser
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
