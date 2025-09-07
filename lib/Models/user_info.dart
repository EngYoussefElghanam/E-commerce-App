final class UserData {
  final String name;
  final String email;
  final String id;
  final String imgUrl;
  final String createdAt;

  UserData({
    required this.name,
    required this.email,
    required this.id,
    required this.createdAt,
    this.imgUrl =
        'https://i.pinimg.com/736x/53/26/39/5326390aa1af79e0e3644ef46e8b0589.jpg',
  });
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({
      'name': name,
      'email': email,
      'id': id,
      'createdAt': createdAt,
      'imgUrl': imgUrl,
    });
    return result;
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      email: map['email'],
      id: map['id'],
      createdAt: map['createdAt'],
      imgUrl: map['imgUrl'],
    );
  }
}
