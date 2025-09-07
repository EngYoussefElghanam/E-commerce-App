import 'package:ecommerce/core/error/failure.dart';

abstract class BaseService {
  Future<T> handleError<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (e) {
      throw _mapErrorToFailure(e);
    }
  }

  Failure _mapErrorToFailure(dynamic error) {
    if (error is FirebaseException) {
      return ServerFailure(error.message ?? 'Firebase error occurred');
    } else if (error is SocketException) {
      return NetworkFailure('No internet connection');
    } else if (error is FormatException) {
      return ValidationFailure('Invalid data format');
    } else {
      return ServerFailure(error.toString());
    }
  }
}

class FirebaseException implements Exception {
  final String? message;
  FirebaseException(this.message);
}

class SocketException implements Exception {
  final String message;
  SocketException(this.message);
}

class FormatException implements Exception {
  final String message;
  FormatException(this.message);
}
