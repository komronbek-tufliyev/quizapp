class QuizQuestionModel {
  final int questionNumber;
  final String question;
  final String correctOption;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;

  QuizQuestionModel({
    required this.questionNumber,
    required this.question,
    required this.correctOption,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      questionNumber: json['questionNumber'],
      question: json['question'],
      correctOption: json['correctOption'],
      optionA: json['optionA'],
      optionB: json['optionB'],
      optionC: json['optionC'],
      optionD: json['optionD'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['questionNumber'] = questionNumber;
    data['question'] = question;
    data['correctOption'] = correctOption;
    data['optionA'] = optionA;
    data['optionB'] = optionB;
    data['optionC'] = optionC;
    data['optionD'] = optionD;
    return data;
  }
}
