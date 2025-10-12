import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/core/theme/theme_notifier.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/attendance_status_provider.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/child_provider.dart';
import 'package:careconnect_mobile/providers/client_provider.dart';
import 'package:careconnect_mobile/providers/clients_child_provider.dart';
import 'package:careconnect_mobile/providers/employee_availability_provider.dart';
import 'package:careconnect_mobile/providers/employee_provider.dart';
import 'package:careconnect_mobile/providers/notification_provider.dart';
import 'package:careconnect_mobile/providers/participant_provider.dart';
import 'package:careconnect_mobile/providers/payment_provider.dart';
import 'package:careconnect_mobile/providers/review_provider.dart';
import 'package:careconnect_mobile/providers/service_provider.dart';
import 'package:careconnect_mobile/providers/service_type_provider.dart';
import 'package:careconnect_mobile/providers/user_provider.dart';
import 'package:careconnect_mobile/providers/workshop_provider.dart';
import 'package:careconnect_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load env file
  await dotenv.load(fileName: ".env");

  final publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];

  if (publishableKey == null || publishableKey.isEmpty) {
    throw Exception("Stripe publishable key not found in .env");
  }

  Stripe.publishableKey = publishableKey;
  await Stripe.instance.applySettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<EmployeeProvider>(
          create: (_) => EmployeeProvider(),
        ),
        ChangeNotifierProvider<AttendanceStatusProvider>(
          create: (_) => AttendanceStatusProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<AppointmentProvider>(
          create: (_) => AppointmentProvider(),
        ),
        ChangeNotifierProvider<ServiceTypeProvider>(
          create: (_) => ServiceTypeProvider(),
        ),
        ChangeNotifierProvider<ServiceProvider>(
          create: (_) => ServiceProvider(),
        ),
        ChangeNotifierProvider<ReviewProvider>(create: (_) => ReviewProvider()),
        ChangeNotifierProvider<EmployeeAvailabilityProvider>(
          create: (_) => EmployeeAvailabilityProvider(),
        ),
        ChangeNotifierProvider<WorkshopProvider>(
          create: (_) => WorkshopProvider(),
        ),
        ChangeNotifierProvider<ClientsChildProvider>(
          create: (_) => ClientsChildProvider(),
        ),
        ChangeNotifierProvider<ClientProvider>(create: (_) => ClientProvider()),
        ChangeNotifierProvider<ChildProvider>(create: (_) => ChildProvider()),
        ChangeNotifierProvider<PaymentProvider>(
          create: (_) => PaymentProvider(),
        ),
        ChangeNotifierProvider<ParticipantProvider>(
          create: (_) => ParticipantProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'CareConnect Admin',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeNotifier.themeMode,
          home: LoginScreen(),
        );
      },
    );
  }
}
