import 'package:ecommerce/Models/order_model.dart';
import 'package:ecommerce/services/firestore_service.dart';

abstract class OrderService {
  Future<void> placeOrder(OrderModel order, String userId);
  Future<List<OrderModel>> fetchUserOrders(String userId);
  Stream<List<OrderModel>> userOrdersStream(String userId);
  Future<OrderModel> fetchOrderById(String orderId, String userId);
}

class OrderImpl implements OrderService {
  @override
  Future<OrderModel> fetchOrderById(String orderId, String userId) async {
    final orders = await FirestoreServices.getData(
      collectionName: 'users/$userId/Orders',
      fromMap: (data, docID) => OrderModel.fromMap(data),
    );
    return orders.firstWhere((order) => order.id == orderId);
  }

  @override
  Future<List<OrderModel>> fetchUserOrders(String userId) async {
    final orders = await FirestoreServices.getData(
      collectionName: 'users/$userId/Orders',
      fromMap: (data, docID) => OrderModel.fromMap(data),
    );
    return orders;
  }

  @override
  Future<void> placeOrder(OrderModel order, String userId) async {
    await FirestoreServices.addData(
      collectionName: 'users/$userId/Orders',
      id: order.id,
      data: order.toMap(),
    );
  }

  @override
  Stream<List<OrderModel>> userOrdersStream(String userId) {
    return FirestoreServices.streamData(
      collectionName: 'users/$userId/Orders',
      fromMap: (data, docID) => OrderModel.fromMap(data),
    );
  }
}
