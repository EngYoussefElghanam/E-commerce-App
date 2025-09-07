part of 'cart_cubit.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

class CartItems extends CartState {
  final List<CartItemModel> items;
  final double subTotal;

  CartItems({required this.items, required this.subTotal});
}
