 

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/api_service.dart';

final productListProvider = FutureProvider.family<List<Product>, String>((ref, keywordId) async {
  return await ApiService.getProducts(keywordId); // Remove the .map<Product>...
});