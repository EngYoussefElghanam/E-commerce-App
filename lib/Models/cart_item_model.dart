class CartItemModel {
  final String id;
  final String size;
  final String name;
  final double price;
  final int quantity;
  final String imgurl;

  CartItemModel({
    required this.imgurl,
    required this.size,
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
  CartItemModel copyWith({
    String? size,
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? imgurl,
  }) {
    return CartItemModel(
      size: size ?? this.size,
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imgurl: imgurl ?? this.imgurl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'size': size,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imgurl': imgurl,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] as String,
      size: map['size'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      imgurl: map['imgurl'] as String,
    );
  }
}
