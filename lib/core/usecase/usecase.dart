abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

abstract class UseCaseResult<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {
  const NoParams();
}

class Params {
  final dynamic data;

  const Params(this.data);
}
