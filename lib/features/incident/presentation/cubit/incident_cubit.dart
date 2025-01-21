import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incident_reporting_app/features/incident/data/models/sub_type_model.dart';
import 'package:incident_reporting_app/features/incident/data/models/type_model.dart';
import 'package:incident_reporting_app/features/incident/domain/entities/incident.dart';
import 'package:incident_reporting_app/features/incident/domain/repositories/incident_repository.dart';
import 'incident_state.dart';

class IncidentCubit extends Cubit<IncidentState> {
  final IncidentRepository repository;

  List<Incident> allIncidents = [];
  List<IncidentTypeModel> incidentsType = [];
  IncidentTypeModel? selectedType;
  SubTypeModel? subTypeModel;
  List<SubTypeModel>? selectedSubTypeList;

  IncidentCubit({required this.repository}) : super(IncidentInitial());
  Future<void> fetchIncidentsType() async {
    emit(IncidentLoading());
    final result = await repository.getIncidentTypes();

    result.fold(
      (failure) =>
          emit(IncidentError(failure.message ?? 'Failed to load incidents')),
      (incidentsTypes) {
        incidentsType = incidentsTypes;
        emit(IncidentsLoaded(allIncidents, incidentsTypes));
      },
    );
  }

  Future<void> fetchIncidents(String startDate) async {
    emit(IncidentLoading());
    final result = await repository.getIncidents(startDate);

    result.fold(
      (failure) =>
          emit(IncidentError(failure.message ?? 'Failed to load incidents')),
      (incidents) {
        allIncidents = incidents;
        emit(IncidentsLoaded(incidents, incidentsType));
      },
    );
  }

  selectIncidentType(IncidentTypeModel selectedIncidentType) {
    selectedType = selectedIncidentType;
    selectedSubTypeList = selectedIncidentType.subTypes;
    print(selectedType?.id);
    emit(IncidentsLoaded(allIncidents, incidentsType,
        incidentsSubTypes: selectedIncidentType.subTypes));
  }

  void filterIncidents({DateTime? date, int? status}) {
    List<Incident> filtered = allIncidents;

    if (date != null) {
      filtered = filtered.where((incident) {
        return incident.createdAt.year == date.year &&
            incident.createdAt.month == date.month &&
            incident.createdAt.day == date.day;
      }).toList();
    }

    if (status != null) {
      filtered =
          filtered.where((incident) => incident.status == status).toList();
    }

    emit(IncidentsFiltered(filtered));
  }

  Future<void> submitIncident({
    required String description,
    required double latitude,
    required double longitude,
    required int status,
    required String issuerId,
  }) async {
    emit(IncidentLoading());
    var newSubmitID = selectedType?.id ?? 0;

    final result = await repository.submitIncident(
      description: description,
      latitude: latitude,
      longitude: longitude,
      status: status,
      typeId: newSubmitID,
      issuerId: issuerId,
    );

    result.fold(
        (failure) =>
            emit(IncidentError(failure.message ?? 'Failed to submit incident')),
        (incident) {
      emit(IncidentSubmitted(incident));
      if (incident != null) allIncidents.insert(0, incident);
      emit(IncidentsLoaded(allIncidents, incidentsType));
    });
  }
}
