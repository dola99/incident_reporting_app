import 'package:dartz/dartz.dart';
import 'package:incident_reporting_app/core/errors/failures.dart';
import 'package:incident_reporting_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:incident_reporting_app/features/auth/domain/entities/auth_data.dart';
import 'package:incident_reporting_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> login(String email) async {
    final success = await remoteDataSource.login(email);
    if (success) {
      return const Right(null);
    } else {
      return Left(ServerFailure(message: 'Login failed'));
    }
  }

  @override
  Future<Either<Failure, AuthData>> verifyOtp(String email, String otp) async {
    final result = await remoteDataSource.verifyOtp(email, otp);
    if (result != null) {
      return Right(result);
    }
    return Left(ServerFailure(message: 'OTP verification failed'));
  }
}
