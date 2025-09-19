import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/core/theme/theme_notifier.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/attendance_status_provider.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/client_provider.dart';
import 'package:careconnect_mobile/providers/clients_child_provider.dart';
import 'package:careconnect_mobile/providers/employee_availability_provider.dart';
import 'package:careconnect_mobile/providers/employee_provider.dart';
import 'package:careconnect_mobile/providers/review_provider.dart';
import 'package:careconnect_mobile/providers/service_provider.dart';
import 'package:careconnect_mobile/providers/service_type_provider.dart';
import 'package:careconnect_mobile/providers/user_provider.dart';
import 'package:careconnect_mobile/providers/workshop_provider.dart';
import 'package:careconnect_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
