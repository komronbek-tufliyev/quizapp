import 'package:cloud_firestore/cloud_firestore.dart';

class ResultModel {
  String name;
  int score;
  int totalScore;
  Timestamp createdAt;

  ResultModel({
    required this.name,
    required this.score,
    required this.createdAt,
    required this.totalScore,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      name: json['name'],
      score: json['score'],
      totalScore: json['totalScore'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'totalScore': totalScore,
      'createdAt': createdAt,
    };
  }
}
