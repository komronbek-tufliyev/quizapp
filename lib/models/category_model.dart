import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String uid;
  final String name;
  final bool displayImage;
  final Timestamp createdAt;
  List<dynamic> categoryList;

  CategoryModel({
    required this.uid,
    required this.name,
    required this.displayImage,
    required this.createdAt,
    required this.categoryList,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      uid: json['id'],
      name: json['name'],
      displayImage: json['displayImage'],
      createdAt: json['createdAt'],
      categoryList: json['categoryList'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'name': name,
      'displayImage': displayImage,
      'createdAt': createdAt,
      'categoryList': categoryList,
    };
  }
}
