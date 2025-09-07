import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  void emitLoading() {
    if (state is BaseState) {
      emit((state as BaseState).copyWith(isLoading: true) as T);
    }
  }

  void emitError(String message) {
    if (state is BaseState) {
      emit(
        (state as BaseState).copyWith(isLoading: false, error: message) as T,
      );
    }
  }

  void emitSuccess() {
    if (state is BaseState) {
      emit((state as BaseState).copyWith(isLoading: false, error: null) as T);
    }
  }
}

abstract class BaseState {
  final bool isLoading;
  final String? error;

  const BaseState({this.isLoading = false, this.error});

  BaseState copyWith({bool? isLoading, String? error});
}
