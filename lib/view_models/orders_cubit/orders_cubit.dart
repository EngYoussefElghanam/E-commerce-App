import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/Models/order_model.dart';
import 'package:ecommerce/services/order_service.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderService orderService;

  OrdersCubit({required this.orderService}) : super(OrdersLoading());

  void loadOrders() async {
    emit(OrdersLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const OrdersError("User not logged in"));
        return;
      }

      final orders = await orderService.fetchUserOrders(user.uid);
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  void watchOrders() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(const OrdersError("User not logged in"));
      return;
    }

    emit(OrdersLoading());
    orderService.userOrdersStream(user.uid).listen((orders) {
      emit(OrdersLoaded(orders));
    }, onError: (e) => emit(OrdersError(e.toString())));
  }
}
