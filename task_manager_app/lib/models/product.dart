class Product {
  final String id;
  final String keywordId;
  final String keyword;
  final String productId;
  final String brandName;
  final String productName;
  final String productRating;
  final String productRatingCount;
  final String currentProductPrice;
  final String originalProductPrice;
  final String productColor;
  final String productDescription;
  final List<String> productSizesAvailable;
  final List<String> productSizesComingSoon;
  final List<String> productSizesOutOfStock;
  final List<String> productImageUrls;
  final String additionalInformation;
  final String productUrl;

  Product({
    required this.id,
    required this.keywordId,
    required this.keyword,
    required this.productId,
    required this.brandName,
    required this.productName,
    required this.productRating,
    required this.productRatingCount,
    required this.currentProductPrice,
    required this.originalProductPrice,
    required this.productColor,
    required this.productDescription,
    required this.productSizesAvailable,
    required this.productSizesComingSoon,
    required this.productSizesOutOfStock,
    required this.productImageUrls,
    required this.additionalInformation,
    required this.productUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] is Map ? json['_id']['\$oid'] ?? '' : json['_id'] ?? '',
      keywordId: json['keyword_id'] ?? '',
      keyword: json['keyword'] ?? '',
      productId: json['product_id'] ?? '',
      brandName: json['brand_name'] ?? '',
      productName: json['product_name'] ?? '',
      productRating: json['product_rating'] ?? '',
      productRatingCount: json['product_rating_count'] ?? '',
      currentProductPrice: json['current_product_price'] ?? '',
      originalProductPrice: json['original_product_price'] ?? '',
      productColor: json['product_color'] ?? '',
      productDescription: json['product_description'] ?? '',
      productSizesAvailable: List<String>.from(json['product_sizes_available'] ?? []),
      productSizesComingSoon: List<String>.from(json['product_sizes_coming_soon'] ?? []),
      productSizesOutOfStock: List<String>.from(json['product_sizes_out_of_stock'] ?? []),
      productImageUrls: List<String>.from(json['product_image_urls'] ?? []),
      additionalInformation: json['additional_information'] ?? '',
      productUrl: json['product_url'] ?? '',
    );
  }
}
