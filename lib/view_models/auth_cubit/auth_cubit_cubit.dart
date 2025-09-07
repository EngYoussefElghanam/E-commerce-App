import 'package:bloc/bloc.dart';
import 'package:ecommerce/services/auth_service.dart';

part 'auth_cubit_state.dart';

class AuthCubitCubit extends Cubit<AuthCubitState> {
  AuthCubitCubit() : super(AuthCubitInitial());
  final _authServices = AuthServicesImpl();
  Future<void> login(String email, String password) async {
    emit(AuthCubitLoading());
    try {
      final result = await _authServices.login(email, password);
      if (result) {
        emit(AuthCubitSuccess());
      } else if (!result) {
        {
          emit(AuthCubitFailure(message: 'Invalid email or password'));
        }
      }
    } catch (e) {
      emit(AuthCubitFailure(message: e.toString()));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthCubitLoading());
    try {
      final result = await _authServices.register(email, password, name);
      if (result) {
        emit(AuthCubitSuccess());
      } else {
        emit(AuthCubitFailure(message: 'Invalid email or password'));
      }
    } catch (e) {
      emit(AuthCubitFailure(message: e.toString()));
    }
  }

  void checkAuth() {
    final user = _authServices.currentUser();
    if (user != null) {
      emit(const AuthCubitSuccess());
    }
  }

  Future<void> logout() async {
    emit(AuthCubitLoggingOut());
    try {
      await _authServices.logOut();
      emit(AuthCubitLoggedOut());
    } catch (e) {
      emit(AuthCubitLoggedOutFailure(message: e.toString()));
    }
  }

  Future<void> GoogleLogin() async {
    emit(GoogleAuthenticating());
    try {
      final result = await _authServices.googleLogin();
      if (result) {
        emit(GoogleAuthenticated());
      } else {
        emit(GoogleAuthenticatingFailure(message: 'Failed to login'));
      }
    } catch (e) {
      emit(GoogleAuthenticatingFailure(message: e.toString()));
    }
  }

  Future<void> FacebookLogin() async {
    emit(FacebookAuthenticating());
    try {
      final result = await _authServices.facebookLogin();
      if (result) {
        emit(FacebookAuthenticated());
      } else {
        emit(FacebookAuthenticatingFailure(message: 'Failed to login'));
      }
    } catch (e) {
      emit(FacebookAuthenticatingFailure(message: e.toString()));
    }
  }
}
