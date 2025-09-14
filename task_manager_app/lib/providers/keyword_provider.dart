 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/keyword.dart';
import '../services/api_service.dart';

final keywordProvider = FutureProvider<List<Keyword>>((ref) async {
return ApiService.getKeywords();

});
