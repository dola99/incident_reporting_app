// lib/core/network/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:incident_reporting_app/core/helper/secure_storage_service.dart';

class ApiClient {
  final String baseUrl;
  final SecureStorageService _secureStorage = SecureStorageService();

  ApiClient({required this.baseUrl});

  Future<http.Response> get(String endpoint,
      {Map<String, String>? queryParams}) async {
    String token = '';
    final storedToken = await _secureStorage.readValue('auth_token');
    if (storedToken != null) {
      token = storedToken;
    }

    Uri url = Uri.parse(baseUrl + endpoint);
    if (queryParams != null && queryParams.isNotEmpty) {
      url = Uri.parse(baseUrl + endpoint).replace(queryParameters: queryParams);
    }

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    String token = '';
    final storedToken = await _secureStorage.readValue('auth_token');
    if (storedToken != null) {
      token = storedToken;
    }

    final url = Uri.parse(baseUrl + endpoint);
    String encodedBody = '{}';
    if (body != null) {
      encodedBody = jsonEncode(body);
    }

    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: encodedBody,
    );
  }

  Future<http.Response> put(String endpoint,
      {Map<String, dynamic>? body}) async {
    String token = '';
    final storedToken = await _secureStorage.readValue('auth_token');
    if (storedToken != null) {
      token = storedToken;
    }

    final url = Uri.parse(baseUrl + endpoint);
    String encodedBody = '{}';
    if (body != null) {
      encodedBody = jsonEncode(body);
    }

    return http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: encodedBody,
    );
  }

  Future<http.StreamedResponse> postMultipart(
    String endpoint, {
    required String filePathKey,
    required String filePath,
  }) async {
    String token = '';
    final storedToken = await _secureStorage.readValue('auth_token');
    if (storedToken != null) {
      token = storedToken;
    }

    final url = Uri.parse(baseUrl + endpoint);
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(await http.MultipartFile.fromPath(filePathKey, filePath));

    return request.send();
  }
}
