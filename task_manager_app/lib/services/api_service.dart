 

import 'package:dio/dio.dart';
import '../models/keyword.dart';
import '../models/product.dart';
import '../models/task.dart';
class ApiService {
  static final dio = Dio(
    BaseOptions(
      baseUrl: "https://task-management-flutter-app-1.onrender.com/api",
      // baseUrl: 'http://10.0.2.2:5000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );

  /// Fetch all keywords
  static Future<List<Keyword>> getKeywords() async {
    try {
      final Response res = await dio.get('/keywords');
      if (res.statusCode == 200 && res.data is List) {
        return (res.data as List)
            .map((e) => Keyword.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Invalid keywords response");
      }
    } on DioException catch (e) {
      throw Exception("Failed to fetch keywords: ${e.message}");
    }
  }

  /// Fetch products by keywordId
  static Future<List<Product>> getProducts(String keywordId) async {
  try {
    print("➡️ Fetching products for keywordId: $keywordId"); // 👀 DEBUG

    final Response res = await dio.get(
      '/products',
      queryParameters: {'keyword': keywordId},
    );

    print("✅ API called: /products?keyword=$keywordId"); // 👀 DEBUG
    print("📥 Response data: ${res.data}"); // 👀 DEBUG

    if (res.statusCode == 200 && res.data is List) {
      return (res.data as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Invalid products response: ${res.data}");
    }
  } on DioException catch (e) {
    print("❌ API error: ${e.message}");
    throw Exception("Failed to fetch products: ${e.message}");
  }
}

  // static Future<List<Product>> getProducts(String keywordId) async {
  //   try {
  //     final Response res = await dio.get(
  //       '/products',
  //       queryParameters: {'keyword': keywordId}, // ✅ matches backend
  //     );
  //     if (res.statusCode == 200 && res.data is List) {
  //       return (res.data as List)
  //           .map((e) => Product.fromJson(e as Map<String, dynamic>))
  //           .toList();
  //     } else {
  //       throw Exception("Invalid products response");
  //     }
  //   } on DioException catch (e) {
  //     throw Exception("Failed to fetch products: ${e.message}");
  //   }
  // }

  /// Fetch single product by ID
  static Future<Product> getProductById(String productId) async {
    try {
      final Response res = await dio.get('/products/$productId');
      if (res.statusCode == 200 && res.data is Map) {
        return Product.fromJson(res.data as Map<String, dynamic>);
      } else {
        throw Exception("Invalid product response");
      }
    } on DioException catch (e) {
      throw Exception("Failed to fetch product: ${e.message}");
    }
  }

 

//   // ===== TASK METHODS =====
//   static Future<List<Task>> getTasks() async {
//     final res = await dio.get('/tasks');
//     if (res.statusCode == 200 && res.data is List) {
//       return (res.data as List)
//           .map((e) => Task.fromJson(e as Map<String, dynamic>))
//           .toList();
//     } else {
//       throw Exception("Failed to fetch tasks");
//     }
//   }

//   static Future<Task> createTask(String title, String keywordId) async {
//     final res = await dio.post('/tasks', data: {'title': title, 'keyword_id': keywordId, 'isCompleted': false});
//     print(res.data);
//     if (res.statusCode == 201 && res.data is Map) {
//       return Task.fromJson(res.data as Map<String, dynamic>);
//     } else {
//       throw Exception("Failed to create task");
//     }
//   }

//  static Future<Task> updateTask(
//   String id,
//   String title,
//   String keywordId, {
//   bool? isCompleted,
// }) async {
//   final res = await dio.put(
//     '/tasks/$id',
//     data: {
//       'title': title,
//       'keyword_Id': keywordId, // or 'keyword_id' if backend expects that
//       if (isCompleted != null) "completed": isCompleted, // ✅ correct toggle
//     },
//   );
//   if (res.statusCode == 200 && res.data is Map) {
//     return Task.fromJson(res.data as Map<String, dynamic>);
//   } else {
//     throw Exception("Failed to update task");
//   }
// }


//   static Future<void> deleteTask(String id) async {
//     final res = await dio.delete('/tasks/$id');
//     if (res.statusCode != 200) {
//       throw Exception("Failed to delete task");
//     }
//   }

// ===== TASK METHODS =====
static Future<List<Task>> getTasks() async {
  final res = await dio.get('/tasks');
  if (res.statusCode == 200 && res.data is List) {
    return (res.data as List)
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception("Failed to fetch tasks");
  }
}

static Future<Task> createTask(String title, String? keywordId) async {
  final res = await dio.post(
    '/tasks',
    data: {
      'title': title,
      if (keywordId != null) 'keyword_id': keywordId,
      'completed': false,
    },
  );
  if (res.statusCode == 201 && res.data is Map) {
    return Task.fromJson(res.data as Map<String, dynamic>);
  } else {
    throw Exception("Failed to create task");
  }
}

static Future<Task> updateTask(
  String id,
  String title,
  String? keywordId, {
  bool? isCompleted,
}) async {
  final res = await dio.put(
    '/tasks/$id',
    data: {
      'title': title,
      if (keywordId != null) 'keyword_id': keywordId,
      if (isCompleted != null) 'completed': isCompleted,
    },
  );
  if (res.statusCode == 200 && res.data is Map) {
    return Task.fromJson(res.data as Map<String, dynamic>);
  } else {
    throw Exception("Failed to update task");
  }
}

static Future<void> deleteTask(String id) async {
  final res = await dio.delete('/tasks/$id');
  if (res.statusCode != 200) {
    throw Exception("Failed to delete task");
  }
}


}
