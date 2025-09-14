// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/product.dart';
// import '../services/api_service.dart';

// final productListProvider = FutureProvider.family<List<Product>, String>((ref, keywordId) async {
//   final data = await ApiService.fetchProducts(keywordId);
//   return data.map<Product>((json) => Product.fromJson(json)).toList();
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/api_service.dart';

final productListProvider = FutureProvider.family<List<Product>, String>((ref, keywordId) async {
  return await ApiService.getProducts(keywordId); // Remove the .map<Product>...
});