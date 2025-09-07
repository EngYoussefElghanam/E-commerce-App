part of 'add_card_cubit.dart';

sealed class AddCardState {}

final class AddCardInitial extends AddCardState {}

final class AddCardLoading extends AddCardState {}

final class AddCardSuccess extends AddCardState {}

final class AddCardFailure extends AddCardState {
  final String message;
  AddCardFailure({required this.message});
}
