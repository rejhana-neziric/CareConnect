import 'package:careconnect_admin/providers/appointment_provider.dart';
import 'package:careconnect_admin/providers/attendance_status_provider.dart';
import 'package:careconnect_admin/providers/auth_provider.dart';
import 'package:careconnect_admin/providers/child_provider.dart';
import 'package:careconnect_admin/providers/children_diagnosis_provider.dart';
import 'package:careconnect_admin/providers/client_provider.dart';
import 'package:careconnect_admin/providers/clients_child_form_provider.dart';
import 'package:careconnect_admin/providers/clients_child_provider.dart';
import 'package:careconnect_admin/providers/employee_availability_provider.dart';
import 'package:careconnect_admin/providers/employee_form_availability_provider.dart';
import 'package:careconnect_admin/providers/employee_form_provider.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:careconnect_admin/providers/notification_provider.dart';
import 'package:careconnect_admin/providers/participant_provider.dart';
import 'package:careconnect_admin/providers/permission_provider.dart';
import 'package:careconnect_admin/providers/report_provider.dart';
import 'package:careconnect_admin/providers/review_provider.dart';
import 'package:careconnect_admin/providers/role_permissions_provider.dart';
import 'package:careconnect_admin/providers/role_provider.dart';
import 'package:careconnect_admin/providers/service_form_provider.dart';
import 'package:careconnect_admin/providers/service_provider.dart';
import 'package:careconnect_admin/providers/service_type_from_provider.dart';
import 'package:careconnect_admin/providers/service_type_provider.dart';
import 'package:careconnect_admin/providers/user_form_provider.dart';
import 'package:careconnect_admin/providers/user_provider.dart';
import 'package:careconnect_admin/providers/workshop_form_provider.dart';
import 'package:careconnect_admin/providers/workshop_provider.dart';
import 'package:careconnect_admin/screens/login_screen.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/core/theme/theme_notifier.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<EmployeeProvider>(
          create: (_) => EmployeeProvider(),
        ),
        ChangeNotifierProvider<AttendanceStatusProvider>(
          create: (_) => AttendanceStatusProvider(),
        ),
        ChangeNotifierProvider<EmployeeFormProvider>(
          create: (_) => EmployeeFormProvider(),
        ),
        ChangeNotifierProvider<ClientProvider>(create: (_) => ClientProvider()),
        ChangeNotifierProvider<ClientsChildProvider>(
          create: (_) => ClientsChildProvider(),
        ),
        ChangeNotifierProvider<ClientsChildFormProvider>(
          create: (_) => ClientsChildFormProvider(),
        ),
        ChangeNotifierProvider<ChildrenDiagnosisProvider>(
          create: (_) => ChildrenDiagnosisProvider(),
        ),
        ChangeNotifierProvider<ServiceProvider>(
          create: (_) => ServiceProvider(),
        ),
        ChangeNotifierProvider<ServiceFormProvider>(
          create: (_) => ServiceFormProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<WorkshopProvider>(
          create: (_) => WorkshopProvider(),
        ),
        ChangeNotifierProvider<WorkshopFormProvider>(
          create: (_) => WorkshopFormProvider(),
        ),
        ChangeNotifierProvider<ParticipantProvider>(
          create: (_) => ParticipantProvider(),
        ),
        ChangeNotifierProvider<ReviewProvider>(create: (_) => ReviewProvider()),
        ChangeNotifierProvider<ServiceTypeProvider>(
          create: (_) => ServiceTypeProvider(),
        ),
        ChangeNotifierProvider<ServiceTypeFromProvider>(
          create: (_) => ServiceTypeFromProvider(),
        ),
        ChangeNotifierProvider<EmployeeAvailabilityProvider>(
          create: (_) => EmployeeAvailabilityProvider(),
        ),
        ChangeNotifierProvider<EmployeeFormAvailabilityProvider>(
          create: (_) => EmployeeFormAvailabilityProvider(),
        ),
        ChangeNotifierProvider<AppointmentProvider>(
          create: (_) => AppointmentProvider(),
        ),
        ChangeNotifierProvider<ChildProvider>(create: (_) => ChildProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<UserFormProvider>(
          create: (_) => UserFormProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ReportProvider>(create: (_) => ReportProvider()),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider<RolePermissionsProvider>(
          create: (_) => RolePermissionsProvider(),
        ),
        ChangeNotifierProvider<RoleProvider>(create: (_) => RoleProvider()),
        ProxyProvider<AuthProvider, PermissionProvider>(
          update: (_, authProvider, __) => PermissionProvider(authProvider),
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
