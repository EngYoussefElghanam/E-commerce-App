class Location {
  final String id;
  final String city;
  final String country;
  final String imageURL;
  final bool isSelected;

  Location({
    required this.id,
    required this.city,
    required this.country,
    this.imageURL = 'assets/images/map.jpg',
    this.isSelected = false,
  });
  Location copyWith({
    String? id,
    String? city,
    String? country,
    String? imageURL,
    bool? isSelected,
  }) {
    return Location(
      id: id ?? this.id,
      city: city ?? this.city,
      country: country ?? this.country,
      imageURL: imageURL ?? this.imageURL,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'city': city,
      'country': country,
      'imageURL': imageURL,
      'isSelected': isSelected,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] as String,
      city: map['city'] as String,
      country: map['country'] as String,
      imageURL: map['imageURL'] as String,
      isSelected: map['isSelected'] as bool,
    );
  }
}
