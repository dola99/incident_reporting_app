import 'package:incident_reporting_app/features/auth/domain/entities/auth_data.dart';

class AuthDataModel extends AuthData {
  AuthDataModel({required super.token, required super.roles});

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    String tempToken = '';
    if (json['token'] != null) {
      tempToken = json['token'];
    }
    List<String> tempRoles = [];
    if (json['roles'] != null) {
      tempRoles = (json['roles'] as List<dynamic>).cast<String>();
    }
    return AuthDataModel(token: tempToken, roles: tempRoles);
  }
}
