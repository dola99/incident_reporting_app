import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incident_reporting_app/bootstrap.dart';
import 'package:incident_reporting_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:incident_reporting_app/features/auth/presentation/screens/login_page.dart';
import 'package:incident_reporting_app/features/auth/presentation/screens/otp_page.dart';
import 'package:incident_reporting_app/features/incident/presentation/cubit/incident_cubit.dart';
import 'package:incident_reporting_app/features/incident/presentation/screens/incident_list_page.dart';
import 'package:incident_reporting_app/injection_container.dart' as di;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  bootstrap(() => const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (_) => di.getIt<AuthCubit>(),
          ),
          BlocProvider<IncidentCubit>(
            create: (_) => di.getIt<IncidentCubit>()..fetchIncidentsType(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/login':
                return MaterialPageRoute(
                    builder: (context) => const LoginPage());
              case '/otp':
                final args = settings.arguments as Map<String, dynamic>?;
                final email = args != null && args['email'] != null
                    ? args['email'] as String
                    : '';

                return MaterialPageRoute(
                    builder: (context) => OtpPage(email: email));
              case '/incident':
                return MaterialPageRoute(
                    builder: (context) => const IncidentListPage());
              default:
                return MaterialPageRoute(
                    builder: (context) => const LoginPage());
            }
          },
        ));
  }
}
