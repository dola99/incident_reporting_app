class SubTypeModel {
  final int id;
  final String arabicName;
  final String englishName;
  final int categoryId;

  SubTypeModel({
    required this.id,
    required this.arabicName,
    required this.englishName,
    required this.categoryId,
  });

  factory SubTypeModel.fromJson(Map<String, dynamic> json) {
    return SubTypeModel(
      id: json['id'] ?? 0,
      arabicName: json['arabicName'] ?? '',
      englishName: json['englishName'] ?? '',
      categoryId: json['categoryId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabicName': arabicName,
      'englishName': englishName,
      'categoryId': categoryId,
    };
  }
}
