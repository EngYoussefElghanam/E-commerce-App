import 'package:ecommerce/core/models/base_model.dart';

// ignore: constant_identifier_names
enum ProductSize { S, M, L, XL, XXL }

class ProductModel extends BaseModelWithId {
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String category;
  final bool isFavorite;
  final double rating;
  final int reviewCount;
  final ProductSize size;

  ProductModel({
    required super.id,
    required this.name,
    required this.price,
    this.description = '',
    required this.imageUrl,
    required this.category,
    this.isFavorite = false,
    this.rating = 4.5,
    this.reviewCount = 100,
    this.size = ProductSize.M,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    String? category,
    bool? isFavorite,
    double? rating,
    int? reviewCount,
    ProductSize? size,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      size: size ?? this.size,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'isFavorite': isFavorite,
      'rating': rating,
      'reviewCount': reviewCount,
      'size': size.name,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return ProductModel(
      id: docId ?? map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      rating: (map['rating'] ?? 4.5).toDouble(),
      reviewCount: map['reviewCount'] ?? 100,
      size: ProductSize.values.firstWhere(
        (s) => s.name == (map['size'] ?? ProductSize.M.name),
        orElse: () => ProductSize.M,
      ),
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() => 'ProductModel(id: $id, name: $name, price: $price)';

  static List<ProductModel> fromList(List<dynamic> list) {
    return list.map((item) => ProductModel.fromMap(item)).toList();
  }
}
