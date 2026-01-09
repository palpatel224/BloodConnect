import 'package:bloodconnect/donor_finder/donor_info/2_application/screens/bloc/donor_info_bloc.dart';
import 'package:bloodconnect/donor_finder/request_screen/2_application/screens/bloc/request_screen_bloc.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/2_application/screens/bloc/health_questionnaire_bloc.dart';
import 'package:bloodconnect/firebase_options.dart';
import 'package:bloodconnect/health_worker/donation_appointments/2_application/bloc/appointment_list_bloc.dart';
import 'package:bloodconnect/health_worker/donor_list/2_application/screens/bloc/donor_list_bloc.dart';
import 'package:bloodconnect/health_worker/manage_request/2_application/screens/bloc/manage_request_screen_bloc.dart';
import 'package:bloodconnect/health_worker/worker_info/2_application/bloc/health_worker_info_bloc.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/2_application/bloc/health_worker_home_bloc.dart';
import 'package:bloodconnect/login/2_application/screens/auth_page.dart';
import 'package:bloodconnect/login/2_application/screens/bloc/login_screen_bloc.dart';
import 'package:bloodconnect/service_locator.dart';
import 'package:bloodconnect/splash_screen.dart';
import 'package:bloodconnect/theme_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        BlocProvider(create: (context) => sl<LoginScreenBloc>()),
        BlocProvider(create: (context) => sl<DonorInfoBloc>()),
        BlocProvider(create: (context) => sl<HealthWorkerInfoBloc>()),
        BlocProvider(create: (context) => sl<RequestScreenBloc>()),
        BlocProvider(create: (context) => sl<ManageRequestScreenBloc>()),
        BlocProvider(create: (context) => sl<HealthWorkerHomeBloc>()),
        BlocProvider(create: (context) => sl<DonorListBloc>()),
        BlocProvider(create: (context) => sl<AppointmentListBloc>()),
        BlocProvider(create: (context) => sl<HealthQuestionnaireBloc>()),
      ],
      child: Consumer<ThemeService>(builder: (context, themeService, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Blood Connect',
          themeMode:
              themeService.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFE83A30),
              secondary: Color(0xFF3870FF),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFFFF6B62),
              secondary: Color(0xFF70A0FF),
            ),
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/auth': (context) => const AuthPage(),
          },
        );
      }),
    );
  }
}
