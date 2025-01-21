import 'package:dartz/dartz.dart';
import 'package:incident_reporting_app/core/errors/failures.dart';
import 'package:incident_reporting_app/features/incident/data/datasource/incident_remote_data_source.dart';
import 'package:incident_reporting_app/features/incident/data/models/type_model.dart';
import 'package:incident_reporting_app/features/incident/domain/entities/incident.dart';
import 'package:incident_reporting_app/features/incident/domain/repositories/incident_repository.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  late final IncidentRemoteDataSource remoteDataSource;
  IncidentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<IncidentTypeModel>>> getIncidentTypes() async {
    final result = await remoteDataSource.getIncidentTypes();
    if (result != null) {
      return Right(result);
    }
    return Left(ServerFailure(message: 'Failed to load incident types'));
  }

  @override
  Future<Either<Failure, List<Incident>>> getIncidents(String startDate) async {
    final result = await remoteDataSource.getIncidents(startDate);
    if (result != null) {
      return Right(result);
    }
    return Left(ServerFailure(message: 'Failed to load incidents'));
  }

  @override
  Future<Either<Failure, Incident?>> submitIncident({
    required String description,
    required double latitude,
    required double longitude,
    required int status,
    required int typeId,
    required String issuerId,
  }) async {
    try {
      final incident = await remoteDataSource.submitIncident(
        description: description,
        latitude: latitude,
        longitude: longitude,
        status: status,
        typeId: typeId,
        issuerId: issuerId,
      );
      return Right(incident);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> uploadIncidentImage(
      String incidentId, String filePath) async {
    final success =
        await remoteDataSource.uploadIncidentImage(incidentId, filePath);
    if (success) {
      return const Right(true);
    }
    return Left(ServerFailure(message: 'Upload image failed'));
  }

  @override
  Future<Either<Failure, Incident>> changeStatus(
      String incidentId, int newStatus) async {
    final changed = await remoteDataSource.changeStatus(incidentId, newStatus);
    if (changed != null) {
      return Right(changed);
    }
    return Left(ServerFailure(message: 'Change status failed'));
  }
}
