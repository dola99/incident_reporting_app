// lib/features/incident/presentation/cubit/incident_state.dart

import 'package:equatable/equatable.dart';
import 'package:incident_reporting_app/features/incident/data/models/sub_type_model.dart';
import 'package:incident_reporting_app/features/incident/data/models/type_model.dart';
import 'package:incident_reporting_app/features/incident/domain/entities/incident.dart';

abstract class IncidentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IncidentInitial extends IncidentState {}

class IncidentLoading extends IncidentState {}

class IncidentsLoaded extends IncidentState {
  final List<Incident> incidents;
  final List<IncidentTypeModel> incidentsTypes;
  final List<SubTypeModel>? incidentsSubTypes;

  IncidentsLoaded(this.incidents, this.incidentsTypes,
      {this.incidentsSubTypes});

  @override
  List<Object?> get props => [incidents];
}

class IncidentsFiltered extends IncidentState {
  final List<Incident> filteredIncidents;

  IncidentsFiltered(this.filteredIncidents);

  @override
  List<Object?> get props => [filteredIncidents];
}

class IncidentSubmitted extends IncidentState {
  final Incident? incident;

  IncidentSubmitted(this.incident);

  @override
  List<Object?> get props => [incident];
}

class IncidentError extends IncidentState {
  final String message;

  IncidentError(this.message);

  @override
  List<Object?> get props => [message];
}
