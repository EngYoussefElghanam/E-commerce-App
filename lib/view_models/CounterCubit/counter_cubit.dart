import 'package:bloc/bloc.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit({int initialValue = 1})
    : _counter = initialValue,
      super(CounterValue(counterValue: initialValue));

  int _counter;

  void increment() {
    if (_counter < 99) {
      _counter++;
      emit(CounterValue(counterValue: _counter));
    }
  }

  void decrement() {
    if (_counter > 1) {
      _counter--;
      emit(CounterValue(counterValue: _counter));
    }
  }
}
