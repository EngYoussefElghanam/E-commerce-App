class OrderModel {
  final String id;
  final String userId;
  final List<String> productsNames;
  final List<int> productsQuantities;
  final double totalPrice;
  final DateTime orderDate;
  final String status;
  final String shippingAddress;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.userId,
    required this.productsNames,
    required this.productsQuantities,
    required this.totalPrice,
    required this.orderDate,
    this.status = 'pending',
    required this.shippingAddress,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productsNames': productsNames,
      'productsQuantities': productsQuantities,
      'totalPrice': totalPrice,
      'orderDate': orderDate.millisecondsSinceEpoch,
      'status': status,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      productsNames: List<String>.from(map['productsNames']),
      productsQuantities: List<int>.from(map['productsQuantities']),
      totalPrice: (map['totalPrice'] as num).toDouble(),
      orderDate: DateTime.fromMillisecondsSinceEpoch(map['orderDate']),
      status: map['status'] ?? 'pending',
      shippingAddress: map['shippingAddress'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
    );
  }
}
