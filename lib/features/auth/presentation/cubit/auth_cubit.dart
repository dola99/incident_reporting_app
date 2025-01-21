import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incident_reporting_app/core/helper/secure_storage_service.dart';
import 'package:incident_reporting_app/core/utils/form_validator.dart';
import 'package:incident_reporting_app/features/auth/domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late final AuthRepository repository;
  late final SecureStorageService secureStorage;

  AuthCubit({required this.repository, required this.secureStorage})
      : super(AuthInitial());

  Future<void> login(String email) async {
    final emailError = FormValidator.validateEmail(email);
    if (emailError != null) {
      emit(AuthError(emailError));
      return;
    }

    emit(AuthLoading());
    final result = await repository.login(email.trim());

    result.fold(
      (failure) => emit(AuthError(failure.message ?? 'Login failed')),
      (_) => emit(AuthLoginSuccess()),
    );
  }

  Future<void> verifyOtp(String email, String otp) async {
    final emailError = FormValidator.validateEmail(email);
    final otpError = FormValidator.validateOtp(otp);

    if (emailError != null) {
      emit(AuthError(emailError));
      return;
    }
    if (otpError != null) {
      emit(AuthError(otpError));
      return;
    }

    emit(AuthLoading());
    final result = await repository.verifyOtp(email.trim(), otp.trim());

    result.fold(
      (failure) =>
          emit(AuthError(failure.message ?? 'OTP verification failed')),
      (authData) async {
        await secureStorage.writeValue('auth_token', authData.token);
        emit(AuthOtpVerified(authData));
      },
    );
  }
}
