 
class Keyword {
  final String objectId;   // MongoDB _id (as string)
  final String id;         // keyword id for product API
  final String keyword;    // actual keyword
  final String category;
  final String subcategory;

  Keyword({
    required this.objectId,
    required this.id,
    required this.keyword,
    required this.category,
    required this.subcategory,
  });

  factory Keyword.fromJson(Map<String, dynamic> json) {
    return Keyword(
      objectId: json['_id'] is Map<String, dynamic>
          ? json['_id']['\$oid'] ?? ''
          : json['_id'] ?? '',
      id: json['id'] ?? '',             // ✅ this is the one products API needs
      keyword: json['keyword'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
    );
  }
}
