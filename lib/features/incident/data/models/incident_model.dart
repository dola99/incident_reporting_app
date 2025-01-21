// lib/features/incident/data/models/incident_model.dart

import 'package:incident_reporting_app/features/incident/domain/entities/incident.dart';
import 'package:incident_reporting_app/features/incident/data/models/media_model.dart';

class IncidentModel extends Incident {
  const IncidentModel({
    required super.id,
    required super.description,
    required super.latitude,
    required super.longitude,
    required super.status,
    super.priority,
    required super.typeId,
    required super.issuerId,
    super.assigneeId,
    required super.createdAt,
    required super.updatedAt,
    required super.medias,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    List<MediaModel> mediasList = [];
    if (json['medias'] != null) {
      mediasList = List<Map<String, dynamic>>.from(json['medias'])
          .map((mediaJson) => MediaModel.fromJson(mediaJson))
          .toList();
    }

    return IncidentModel(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      latitude: (json['latitude'] != null)
          ? double.tryParse(json['latitude'].toString()) ?? 0.0
          : 0.0,
      longitude: (json['longitude'] != null)
          ? double.tryParse(json['longitude'].toString()) ?? 0.0
          : 0.0,
      status: json['status'] ?? 0,
      priority: json['priority'],
      typeId: json['typeId'] ?? 0,
      issuerId: json['issuerId'] ?? '',
      assigneeId: json['assigneeId'],
      createdAt: (json['createdAt'] != null)
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: (json['updatedAt'] != null)
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      medias: mediasList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'priority': priority,
      'typeId': typeId,
      'issuerId': issuerId,
      'assigneeId': assigneeId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
