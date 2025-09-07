enum Sizes { S, M, L, XL, XXL }

class ProductItemModel {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String category;
  final bool isFavorite;
  final String rating;
  final String reviewCount;
  final Sizes size;

  ProductItemModel({
    this.rating = '4.5',
    this.reviewCount = '100',
    required this.id,
    required this.name,
    required this.price,
    this.description =
        'lorem ipsum dolor sit amet, consectetur adipiscing elit lorem ipsum dolor sit amet, consectetur adipiscing elit lorem ipsum dolor sit amet, consectetur adipiscing elit lorem ipsum dolor sit amet, consectetur adipiscing elit lorem ipsum dolor sit amet, consectetur adipiscing elit lorem ipsum dolor sit amet, consectetur adipiscing elit lorem ipsum dolor sit amet, consectetur adipiscing elit',
    required this.imageUrl,
    required this.category,
    this.isFavorite = false,
    this.size = Sizes.M,
  });

  ProductItemModel copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    String? category,
    bool? isFavorite,
    String? rating,
    String? reviewCount,
    Sizes? size,
  }) {
    return ProductItemModel(
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

  Map<String, dynamic> toMap() {
    return {
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

  factory ProductItemModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductItemModel(
      id: docId,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      rating: map['rating'] ?? '0',
      reviewCount: map['reviewCount'] ?? '0',
      size: Sizes.values.firstWhere(
        (s) => s.name == (map['size'] ?? Sizes.M.name),
        orElse: () => Sizes.M,
      ),
    );
  }
}

List<ProductItemModel> productItems = [
  ProductItemModel(
    id: '3',
    name: 'Black Tote Bag',
    price: 89.99,
    imageUrl: 'assets/images/tote_bag.jpg',
    category: 'Bags',
  ),
  ProductItemModel(
    id: '4',
    name: 'Beige Wallet',
    price: 15.99,
    imageUrl: 'assets/images/wallet.jpg',
    category: 'Accessories',
  ),
  ProductItemModel(
    id: '5',
    name: 'Classic Sunglasses',
    price: 89.99,
    imageUrl: 'assets/images/sunglasses.jpg',
    category: 'Accessories',
  ),
  ProductItemModel(
    id: '6',
    name: 'Classic Watch',
    price: 199.99,
    imageUrl: 'assets/images/watch.jpg',
    category: 'Accessories',
  ),
  ProductItemModel(
    id: '7',
    name: 'Elegant Shoes',
    price: 79.99,
    imageUrl: 'assets/images/shoes.jpg',
    category: 'Footwear',
  ),
  ProductItemModel(
    id: '8',
    name: 'Sports Sneakers',
    price: 89.99,
    imageUrl: 'assets/images/sneakers.jpg',
    category: 'Footwear',
  ),
  ProductItemModel(
    id: '9',
    name: 'CowBoy Boots',
    price: 129.99,
    imageUrl: 'assets/images/boots.jpg',
    category: 'Footwear',
  ),
  ProductItemModel(
    id: '10',
    name: 'Summer Sandals',
    price: 39.99,
    imageUrl: 'assets/images/sandals.jpg',
    category: 'Footwear',
  ),
  ProductItemModel(
    id: '11',
    name: 'Queen Dress',
    price: 59.99,
    imageUrl: 'assets/images/dress.jpg',
    category: 'Clothing',
  ),
  ProductItemModel(
    id: '12',
    name: 'White T-shirt',
    price: 19.99,
    imageUrl: 'assets/images/tshirt.jpg',
    category: 'Clothing',
  ),
  ProductItemModel(
    id: '13',
    name: 'Blue Jeans',
    price: 49.99,
    imageUrl: 'assets/images/jeans.jpg',
    category: 'Clothing',
  ),
  ProductItemModel(
    id: '14',
    name: 'Leather Jacket',
    price: 89.99,
    imageUrl: 'assets/images/jacket.jpg',
    category: 'Clothing',
  ),
  ProductItemModel(
    id: '15',
    name: 'White Sweater',
    price: 59.99,
    imageUrl: 'assets/images/sweater.jpg',
    category: 'Clothing',
  ),
];
