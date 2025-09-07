part of 'auth_cubit_cubit.dart';

sealed class AuthCubitState {
  const AuthCubitState();
}

final class AuthCubitInitial extends AuthCubitState {}

final class AuthCubitLoading extends AuthCubitState {}

final class AuthCubitSuccess extends AuthCubitState {
  const AuthCubitSuccess();
}

final class AuthCubitFailure extends AuthCubitState {
  final String message;
  const AuthCubitFailure({required this.message});
}

final class AuthCubitLoggedOut extends AuthCubitState {}

final class AuthCubitLoggingOut extends AuthCubitState {}

final class AuthCubitLoggedOutFailure extends AuthCubitState {
  final String message;
  const AuthCubitLoggedOutFailure({required this.message});
}

final class GoogleAuthenticating extends AuthCubitState {}

final class GoogleAuthenticated extends AuthCubitState {}

final class GoogleAuthenticatingFailure extends AuthCubitState {
  final String message;
  const GoogleAuthenticatingFailure({required this.message});
}

final class FacebookAuthenticating extends AuthCubitState {}

final class FacebookAuthenticated extends AuthCubitState {}

final class FacebookAuthenticatingFailure extends AuthCubitState {
  final String message;
  const FacebookAuthenticatingFailure({required this.message});
}
