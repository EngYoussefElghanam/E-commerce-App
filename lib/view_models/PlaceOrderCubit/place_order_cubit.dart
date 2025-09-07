import 'package:bloc/bloc.dart';
import 'package:ecommerce/view_models/CartCubit/cart_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/Models/order_model.dart';
import 'package:ecommerce/Models/location.dart';
import 'package:ecommerce/Models/add_card_model.dart';
import 'package:ecommerce/services/order_service.dart';
import 'package:ecommerce/services/checkout_service.dart';

part 'place_order_state.dart';

class PlaceOrderCubit extends Cubit<PlaceOrderState> {
  final OrderService orderService;
  final CheckoutService checkoutService;
  final CartCubit cartCubit;

  PlaceOrderCubit({
    required this.orderService,
    required this.checkoutService,
    required this.cartCubit,
  }) : super(PlaceOrderInitial());

  Future<void> placeOrder({
    required List<String> productNames,
    required List<int> productQuantities,
    required double totalPrice,
  }) async {
    emit(PlacingOrder());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const PlaceOrderError("User not logged in"));
        return;
      }

      /// ✅ Fetch user addresses
      final addresses = await checkoutService.fetchAddresses(user.uid);
      final Location? selectedAddress =
          addresses.where((addr) => addr.isSelected).isNotEmpty
          ? addresses.firstWhere((addr) => addr.isSelected)
          : null;

      if (selectedAddress == null) {
        emit(const PlaceOrderError("No shipping address selected"));
        return;
      }

      /// ✅ Fetch user payment methods
      final methods = await checkoutService.fetchPaymentMethods(user.uid);
      final cardDetailsModel? selectedMethod =
          methods.where((m) => m.checked).isNotEmpty
          ? methods.firstWhere((m) => m.checked)
          : null;

      if (selectedMethod == null) {
        emit(const PlaceOrderError("No payment method selected"));
        return;
      }

      final orderId = const Uuid().v4();
      final order = OrderModel(
        id: orderId,
        userId: user.uid,
        productsNames: productNames,
        productsQuantities: productQuantities,
        totalPrice: totalPrice,
        orderDate: DateTime.now(),
        shippingAddress: "${selectedAddress.city}, ${selectedAddress.country}",
        paymentMethod:
            "**** ${selectedMethod.cardNumber.substring(selectedMethod.cardNumber.length - 4)}",
      );

      /// ✅ Save order
      await orderService.placeOrder(order, user.uid);

      /// ✅ Clear cart
      cartCubit.clearCart();

      emit(OrderPlaced(order));
    } catch (e) {
      emit(PlaceOrderError(e.toString()));
    }
  }
}
