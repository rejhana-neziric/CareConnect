import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/core/theme/theme_notifier.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/attendance_status_provider.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/employee_provider.dart';
import 'package:careconnect_mobile/providers/service_type_provider.dart';
import 'package:careconnect_mobile/providers/user_provider.dart';
import 'package:careconnect_mobile/screens/employee_list_screen.dart';
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

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView());
  }
}

// class LoginPage extends StatelessWidget {
//   LoginPage({super.key});
//   final TextEditingController _usernameController = new TextEditingController();
//   final TextEditingController _passwordController = new TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login")),
//       body: Center(
//         child: Center(
//           child: Container(
//             constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
//             child: Card(
//               child: Column(
//                 children: [
//                   Image.asset(
//                     "assets/images/logo.png",
//                     height: 100,
//                     width: 100,
//                   ),
//                   SizedBox(height: 10),
//                   TextField(
//                     controller: _usernameController,
//                     decoration: InputDecoration(
//                       labelText: "Username",
//                       prefixIcon: Icon(Icons.email),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   TextField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                       prefixIcon: Icon(Icons.password),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       //EmployeeProvider provider = new EmployeeProvider();
//                       print(
//                         "credentials ${_usernameController.text} : ${_passwordController.text}",
//                       );

//                       AuthProvider.username = _usernameController.text;
//                       AuthProvider.password = _passwordController.text;

//                       try {
//                         //var data = await provider.get();
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => EmployeeListScreen(),
//                           ),
//                         );
//                       } on Exception catch (e) {
//                         showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: Text("Error"),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: Text("OK"),
//                               ),
//                             ],
//                             content: Text(e.toString()),
//                           ),
//                         );
//                       }
//                     },
//                     child: Text("Login"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
