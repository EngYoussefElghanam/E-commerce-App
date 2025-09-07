part of 'add_location_cubit.dart';

sealed class AddLocationState {}

final class AddLocationInitial extends AddLocationState {}

final class AddLocationLoading extends AddLocationState {}

final class AddLocationSuccess extends AddLocationState {
  final Location location;
  final List<Location> locations;
  final String message;
  AddLocationSuccess({
    required this.location,
    required this.locations,
    required this.message,
  });
}

final class AddLocationFailure extends AddLocationState {
  final String message;
  AddLocationFailure({required this.message});
}
