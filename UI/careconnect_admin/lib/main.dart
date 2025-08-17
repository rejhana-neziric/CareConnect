import 'package:careconnect_admin/providers/attendance_status_provider.dart';
import 'package:careconnect_admin/providers/children_diagnosis_provider.dart';
import 'package:careconnect_admin/providers/client_provider.dart';
import 'package:careconnect_admin/providers/clients_child_form_provider.dart';
import 'package:careconnect_admin/providers/clients_child_provider.dart';
import 'package:careconnect_admin/providers/employee_form_provider.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:careconnect_admin/providers/service_form_provider.dart';
import 'package:careconnect_admin/providers/service_provider.dart';
import 'package:careconnect_admin/screens/login_screen.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/theme/theme_notifier.dart';
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
        ChangeNotifierProvider(create: (_) => EmployeeFormProvider()),
        ChangeNotifierProvider<ClientProvider>(create: (_) => ClientProvider()),
        ChangeNotifierProvider<ClientsChildProvider>(
          create: (_) => ClientsChildProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ClientsChildFormProvider()),
        ChangeNotifierProvider<ChildrenDiagnosisProvider>(
          create: (_) => ChildrenDiagnosisProvider(),
        ),
        ChangeNotifierProvider<ServiceProvider>(
          create: (_) => ServiceProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ServiceFormProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
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
