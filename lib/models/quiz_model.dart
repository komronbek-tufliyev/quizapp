import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp/models/quiz_question_model.dart';

class QuizModel {
  final String quizId;
  // final String quizCategoryId;
  // final String quizOwnerId;
  final String quizPassword;
  final Timestamp createdAt;
  final String quizName;
  final int numberOfQuestions;
  final int quizTimeDuration;
  final List<QuizQuestionModel> quizQuestions;

  QuizModel({
    required this.quizId,
    // required this.quizCategoryId,
    // required this.quizOwnerId,
    required this.quizPassword,
    required this.createdAt,
    required this.quizName,
    required this.numberOfQuestions,
    required this.quizTimeDuration,
    required this.quizQuestions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    var quizModel = QuizModel(
      quizId: json['quizId'],
      // quizCategoryId: json['quizCategoryId'],
      // quizOwnerId: json['quizOwnerId'],
      quizPassword: json['quizPassword'],
      createdAt: json['createdAt'],
      quizName: json['quizName'],
      numberOfQuestions: json['numberOfQuestions'],
      quizTimeDuration: json['quizTimeDuration'],
      quizQuestions: (json['quizQuestions'] as List)
          .map(
            (element) =>
                QuizQuestionModel.fromJson(element as Map<String, dynamic>),
          )
          .toList(),
    );

    // (json['quizQuestions'] as List).forEach((element) {
    //   print(element);
    // });
    return quizModel;
  }

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      // 'quizCategoryId': quizCategoryId,
      // 'quizOwnerId': quizOwnerId,
      'quizPassword': quizPassword,
      'createdAt': createdAt,
      'quizName': quizName,
      'numberOfQuestions': numberOfQuestions,
      'quizTimeDuration': quizTimeDuration,
      'quizQuestions': quizQuestions.map((e) => e.toJson()).toList(),
    };
  }
}
