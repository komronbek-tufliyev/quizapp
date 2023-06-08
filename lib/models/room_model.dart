import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  String roomId;
  String roomName;
  String quizId;
  String categoryId;
  Timestamp createdAt;
  String quizName;
  String quizPassword;
  String ownerId;
  String ownerName;

  RoomModel({
    required this.roomId,
    required this.roomName,
    required this.quizId,
    required this.categoryId,
    required this.createdAt,
    required this.quizName,
    required this.quizPassword,
    required this.ownerId,
    required this.ownerName,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomId: json['roomId'],
      roomName: json['roomName'],
      quizId: json['quizId'],
      categoryId: json['categoryId'],
      createdAt: json['createdAt'],
      quizName: json['quizName'],
      quizPassword: json['quizPassword'],
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'quizId': quizId,
      'categoryId': categoryId,
      'createdAt': createdAt,
      'quizName': quizName,
      'quizPassword': quizPassword,
      'ownerId': ownerId,
      'ownerName': ownerName,
    };
  }
}
