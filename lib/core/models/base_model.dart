abstract class BaseModel {
  Map<String, dynamic> toMap();

  @override
  String toString() => toMap().toString();
}

abstract class BaseModelWithId extends BaseModel {
  final String id;

  BaseModelWithId({required this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseModelWithId &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
