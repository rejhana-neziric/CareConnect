import 'package:careconnect_admin/providers/auth_provider.dart';
import 'package:careconnect_admin/screens/employee_list_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
            child: Card(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.password),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //EmployeeProvider provider = new EmployeeProvider();
                      print(
                        "credentials ${_usernameController.text} : ${_passwordController.text}",
                      );

                      AuthProvider.username = _usernameController.text;
                      AuthProvider.password = _passwordController.text;

                      try {
                        //var data = await provider.get();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EmployeeListScreen(),
                          ),
                        );
                      } on Exception catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Error"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    child: Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
