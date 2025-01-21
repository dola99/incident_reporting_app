import 'package:dartz/dartz.dart';
import 'package:incident_reporting_app/core/errors/failures.dart';
import 'package:incident_reporting_app/features/auth/domain/entities/auth_data.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(String email);
  Future<Either<Failure, AuthData>> verifyOtp(String email, String otp);
}
