import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:flutter/material.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Employees",
      Column(
        children: [
          Text("List of employees"),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Back"),
          ),
        ],
      ),
    );
  }
}
