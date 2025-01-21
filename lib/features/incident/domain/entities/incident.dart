// lib/features/incident/domain/entities/incident.dart

import 'package:equatable/equatable.dart';
import 'package:incident_reporting_app/features/incident/data/models/media_model.dart';

class Incident extends Equatable {
  final String id;
  final String description;
  final double latitude;
  final double longitude;
  final int status;
  final int? priority;
  final int typeId;
  final String issuerId;
  final String? assigneeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MediaModel> medias;

  const Incident({
    required this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.priority,
    required this.typeId,
    required this.issuerId,
    this.assigneeId,
    required this.createdAt,
    required this.updatedAt,
    required this.medias,
  });

  @override
  List<Object?> get props => [
        id,
        description,
        latitude,
        longitude,
        status,
        priority,
        typeId,
        issuerId,
        assigneeId,
        createdAt,
        updatedAt,
        medias,
      ];
}
