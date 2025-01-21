import 'package:equatable/equatable.dart';
import 'package:incident_reporting_app/features/auth/domain/entities/auth_data.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class FormUpdated extends AuthState {
  final Map<String, String> formData;
  FormUpdated(this.formData);

  @override
  List<Object?> get props => [formData];
}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthOtpVerified extends AuthState {
  final AuthData authData;
  AuthOtpVerified(this.authData);

  @override
  List<Object?> get props => [authData];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
