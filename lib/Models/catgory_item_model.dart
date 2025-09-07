
import 'package:flutter/material.dart';

class CategoryItemModel {
  final String imageUrl;
  final String title;
  final int productCount;
  final Color bgcolor;

  CategoryItemModel({
    required this.imageUrl,
    required this.title,
    required this.productCount,
    required this.bgcolor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageUrl': imageUrl,
      'title': title,
      'productCount': productCount,
      'bgcolor': bgcolor.value,
    };
  }

  factory CategoryItemModel.fromMap(Map<String, dynamic> map) {
    return CategoryItemModel(
      imageUrl: map['imageUrl'] as String,
      title: map['title'] as String,
      productCount: map['productCount'] as int,
      bgcolor: Color(map['bgcolor'] as int),
    );
  }

  CategoryItemModel copyWith({
    String? imageUrl,
    String? title,
    int? productCount,
    Color? bgcolor,
  }) {
    return CategoryItemModel(
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      productCount: productCount ?? this.productCount,
      bgcolor: bgcolor ?? this.bgcolor,
    );
  }
}

