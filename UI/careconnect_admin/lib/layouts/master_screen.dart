import 'package:careconnect_admin/screens/client_list_screen.dart';
import 'package:careconnect_admin/screens/employee_list_screen.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  MasterScreen(this.title, this.child, {super.key});

  final String title;
  final Widget child;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(title: Text("Back"), onTap: () => Navigator.pop(context)),
            ListTile(
              title: Text("Employees"),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EmployeeListScreen()),
              ),
            ),
            ListTile(
              title: Text("Clients"),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ClientListScreen()),
              ),
            ),
          ],
        ),
      ),
      body: widget.child,
    );
  }
}
