part of 'checkout_cubit.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutLoaded extends CheckoutState {
  final List<CartItemModel> cartItems;
  final double total;
  final List<cardDetailsModel>? chosenPaymentMethod;
  final List<Location>? locationList;

  const CheckoutLoaded({
    required this.cartItems,
    required this.total,
    this.chosenPaymentMethod,
    this.locationList,
  });

  @override
  List<Object?> get props => [
    cartItems,
    total,
    chosenPaymentMethod,
    locationList,
  ];
}

final class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError({required this.message});

  @override
  List<Object?> get props => [message];
}
