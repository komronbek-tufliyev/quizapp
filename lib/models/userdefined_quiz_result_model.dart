import 'package:cloud_firestore/cloud_firestore.dart';

class UserdefinedQuizResultModel {
  String roomName;
  String roomId;
  String quizName;
  String ownerName;
  int score;
  Timestamp createdAt;
  int totalScore;

  UserdefinedQuizResultModel({
    required this.roomName,
    required this.roomId,
    required this.quizName,
    required this.ownerName,
    required this.score,
    required this.createdAt,
    required this.totalScore,
  });

  factory UserdefinedQuizResultModel.fromJson(Map<String, dynamic> json) {
    return UserdefinedQuizResultModel(
      roomName: json["Room Name"],
      roomId: json["Room Id"],
      quizName: json["Quiz Name"],
      ownerName: json["Owner Name"],
      score: json["Score"],
      createdAt: json["createdAt"],
      totalScore: json["Total Score"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Room Name": roomName,
      "Room Id": roomId,
      "Quiz Name": quizName,
      "Owner Name": ownerName,
      "Score": score,
      "createdAt": createdAt,
      "Total Score": totalScore,
    };
  }
}
