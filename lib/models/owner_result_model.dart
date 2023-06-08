class OwnerResultModel {
  List<Map<String, dynamic>> result = [];

  OwnerResultModel({required this.result});

  factory OwnerResultModel.fromJson(Map<String, dynamic> json) {
    return OwnerResultModel(
      result: json['Result'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result,
    };
  }
}
