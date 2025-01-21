// lib/features/incident/data/models/category_model.dart

import 'sub_type_model.dart';

class IncidentTypeModel {
  final int id;
  final String arabicName;
  final String englishName;
  final List<SubTypeModel> subTypes;

  IncidentTypeModel({
    required this.id,
    required this.arabicName,
    required this.englishName,
    required this.subTypes,
  });

  factory IncidentTypeModel.fromJson(Map<String, dynamic> json) {
    List<SubTypeModel> subTypesList = [];
    if (json['subTypes'] != null) {
      subTypesList = List<Map<String, dynamic>>.from(json['subTypes'])
          .map((subTypeJson) => SubTypeModel.fromJson(subTypeJson))
          .toList();
    }

    return IncidentTypeModel(
      id: json['id'] ?? 0,
      arabicName: json['arabicName'] ?? '',
      englishName: json['englishName'] ?? '',
      subTypes: subTypesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabicName': arabicName,
      'englishName': englishName,
      'subTypes': subTypes.map((subType) => subType.toJson()).toList(),
    };
  }
}
