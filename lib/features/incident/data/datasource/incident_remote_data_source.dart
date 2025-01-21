import 'dart:convert';
import 'dart:developer';
import 'package:incident_reporting_app/core/network/api_client.dart';
import 'package:incident_reporting_app/features/incident/data/models/incident_model.dart';
import 'package:incident_reporting_app/features/incident/data/models/type_model.dart';

class IncidentRemoteDataSource {
  late final ApiClient apiClient;
  IncidentRemoteDataSource({required this.apiClient});

  Future<List<IncidentTypeModel>?> getIncidentTypes() async {
    final response = await apiClient.get('/types');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log(data.toString());
      if (data is List) {
        return data
            .map((incidentTypeJson) =>
                IncidentTypeModel.fromJson(incidentTypeJson))
            .toList();
      } else {
        return null;
      }
    }
    return null;
  }

  Future<List<IncidentModel>?> getIncidents(String startDate) async {
    final response = await apiClient.get('/incident', queryParams: {
      'startDate': startDate,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['incidents'] != null) {
        final incidentsList = data['incidents'] as List;
        return incidentsList.map((item) {
          return IncidentModel.fromJson(item);
        }).toList();
      }
      return [];
    }
    return null;
  }

  Future<IncidentModel?> submitIncident({
    required String description,
    required double latitude,
    required double longitude,
    required int status,
    required int typeId,
    required String issuerId,
  }) async {
    final body = {
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'typeId': typeId,
      'issuerId': issuerId,
    };
    final response = await apiClient.post('/incident', body: body);
    log(response.body.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['incidents'] != null) {
        List<dynamic> incidentsJson = data['incidents'];
        List<IncidentModel>? incidents = incidentsJson
            .map((incidentJson) => IncidentModel.fromJson(incidentJson))
            .toList();
        return incidents[0];
      }
    }
    return null;
  }

  Future<bool> uploadIncidentImage(String incidentId, String filePath) async {
    final endpoint = '/incident/upload/$incidentId';
    final streamedResponse = await apiClient.postMultipart(
      endpoint,
      filePathKey: 'image',
      filePath: filePath,
    );
    if (streamedResponse.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<IncidentModel?> changeStatus(String incidentId, int newStatus) async {
    final body = {
      'incidentId': incidentId,
      'status': newStatus,
    };
    final response = await apiClient.put('/incident/change-status', body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return IncidentModel.fromJson(data);
    }
    return null;
  }
}
