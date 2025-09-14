 

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
