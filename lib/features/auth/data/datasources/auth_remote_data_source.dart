import 'dart:convert';
import 'package:incident_reporting_app/core/constant/api_constant.dart';
import 'package:incident_reporting_app/core/network/api_client.dart';
import 'package:incident_reporting_app/features/auth/data/models/auth_data_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<bool> login(String email) async {
    final response =
        await apiClient.post(ApiConstant.loginEndPoint, body: {'email': email});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<AuthDataModel?> verifyOtp(String email, String otp) async {
    final response = await apiClient.post(ApiConstant.verifyOtpEndPoint, body: {
      'email': email,
      'otp': otp,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthDataModel.fromJson(data);
    }
    return null;
  }
}
