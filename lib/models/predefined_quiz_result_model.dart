import 'package:cloud_firestore/cloud_firestore.dart';

class PredefinedQuizResultModel {
  String quizName;
  String categoryName;
  int score;
  int totalScore;
  Timestamp createdAt;

  PredefinedQuizResultModel(
      {required this.quizName,
      required this.categoryName,
      required this.score,
      required this.totalScore,
      required this.createdAt});

  factory PredefinedQuizResultModel.fromJson(Map<String, dynamic> json) {
    return PredefinedQuizResultModel(
      quizName: json['quizName'],
      categoryName: json['categoryName'],
      score: json['score'],
      totalScore: json['totalScore'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizName': quizName,
      'categoryName': categoryName,
      'score': score,
      'totalScore': totalScore,
      'createdAt': createdAt,
    };
  }
}
