import 'package:dartz/dartz.dart';
import 'package:incident_reporting_app/core/errors/failures.dart';
import 'package:incident_reporting_app/features/incident/data/models/type_model.dart';
import 'package:incident_reporting_app/features/incident/domain/entities/incident.dart';

abstract class IncidentRepository {
  Future<Either<Failure, List<IncidentTypeModel>>> getIncidentTypes();
  Future<Either<Failure, List<Incident>>> getIncidents(String startDate);
  Future<Either<Failure, Incident?>> submitIncident({
    required String description,
    required double latitude,
    required double longitude,
    required int status,
    required int typeId,
    required String issuerId,
  });
  Future<Either<Failure, bool>> uploadIncidentImage(
      String incidentId, String filePath);
  Future<Either<Failure, Incident>> changeStatus(
      String incidentId, int newStatus);
}
