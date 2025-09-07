part of 'place_order_cubit.dart';

abstract class PlaceOrderState extends Equatable {
  const PlaceOrderState();

  @override
  List<Object?> get props => [];
}

class PlaceOrderInitial extends PlaceOrderState {}

class PlacingOrder extends PlaceOrderState {}

class OrderPlaced extends PlaceOrderState {
  final OrderModel order;
  const OrderPlaced(this.order);

  @override
  List<Object?> get props => [order];
}

class PlaceOrderError extends PlaceOrderState {
  final String message;
  const PlaceOrderError(this.message);

  @override
  List<Object?> get props => [message];
}
