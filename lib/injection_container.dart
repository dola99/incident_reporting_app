import 'package:get_it/get_it.dart';
import 'package:incident_reporting_app/core/constant/api_constant.dart';
import 'package:incident_reporting_app/core/helper/secure_storage_service.dart';
import 'package:incident_reporting_app/core/network/api_client.dart';
import 'package:incident_reporting_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:incident_reporting_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:incident_reporting_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:incident_reporting_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:incident_reporting_app/features/incident/data/datasource/incident_remote_data_source.dart';
import 'package:incident_reporting_app/features/incident/data/repositories/incident_repository_impl.dart';
import 'package:incident_reporting_app/features/incident/domain/repositories/incident_repository.dart';
import 'package:incident_reporting_app/features/incident/presentation/cubit/incident_cubit.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: ApiConstant.baseUrl),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
        repository: getIt<AuthRepository>(),
        secureStorage: getIt<SecureStorageService>()),
  );
  getIt.registerLazySingleton<IncidentRemoteDataSource>(
    () => IncidentRemoteDataSource(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<IncidentRepository>(
    () => IncidentRepositoryImpl(
        remoteDataSource: getIt<IncidentRemoteDataSource>()),
  );

  getIt.registerFactory<IncidentCubit>(
    () => IncidentCubit(repository: getIt<IncidentRepository>()),
  );
}
