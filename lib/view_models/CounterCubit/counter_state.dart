part of 'counter_cubit.dart';

sealed class CounterState {}

final class CounterInitial extends CounterState {}

final class CounterValue extends CounterState {
  final int counterValue;

  CounterValue({required this.counterValue});
}
