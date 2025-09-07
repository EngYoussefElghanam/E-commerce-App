class CarouselItemModel {
  String id;
  String imageUrl;

  CarouselItemModel({required this.id, required this.imageUrl});

  CarouselItemModel copyWith({String? id, String? imageUrl}) {
    return CarouselItemModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'imageUrl': imageUrl};
  }

  factory CarouselItemModel.fromMap(Map<String, dynamic> map) {
    return CarouselItemModel(
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }
}

List<CarouselItemModel> carouselItems = [];
