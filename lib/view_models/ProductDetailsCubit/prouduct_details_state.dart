part of 'prouduct_details_cubit.dart';

sealed class ProuductDetailsState {}

final class ProuductDetailsInitial extends ProuductDetailsState {}

final class ProuductDetailsLoading extends ProuductDetailsState {}

final class ProuductDetailsLoaded extends ProuductDetailsState {
  final ProductItemModel product;

  ProuductDetailsLoaded(this.product);
}

final class ProuductDetailsError extends ProuductDetailsState {
  final String message;

  ProuductDetailsError(this.message);
}
