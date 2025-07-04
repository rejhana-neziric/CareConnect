import 'package:careconnect_mobile/providers/attendance_status_provider.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/employee_provider.dart';
import 'package:careconnect_mobile/screens/employee_list_screen.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.+
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Center(
        child: EmployeeListScreen(),
      ), //const MyHomePage(title: 'Flutter Demo Home Page'),
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
