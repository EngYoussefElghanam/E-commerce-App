part of 'product_cubit.dart';

sealed class ProductsState {}

final class ProductInitial extends ProductsState {}

final class ProductLoading extends ProductsState {}

final class ProductLoaded extends ProductsState {
  final ProductItemModel product;
  ProductLoaded(this.product);
}

final class ProductFailure extends ProductsState {
  final String message;
  ProductFailure(this.message);
}
