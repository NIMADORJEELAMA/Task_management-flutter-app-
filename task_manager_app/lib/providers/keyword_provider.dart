// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/keyword.dart';
// import '../services/api_service.dart';

// final keywordProvider = FutureProvider<List<Keyword>>((ref) async {
//   final data = await ApiService.fetchKeywords();
//   return data.map<Keyword>((json) => Keyword.fromJson(json)).toList();
// });


// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/keyword.dart';
// import '../services/api_service.dart';

// final keywordsProvider = FutureProvider<List<Keyword>>((ref) async {
//   return ApiService.getKeywords();
// });

// final selectedKeywordProvider = StateProvider<Keyword?>((ref) => null);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/keyword.dart';
import '../services/api_service.dart';

final keywordProvider = FutureProvider<List<Keyword>>((ref) async {
return ApiService.getKeywords();

});
