part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  HomeLoaded({required this.carousels, required this.products});
  final List<CarouselItemModel> carousels;
  final List<ProductItemModel> products;
}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
