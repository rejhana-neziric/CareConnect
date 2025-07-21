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
    //final appColors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            //color: appColors.primaryLight ?? Colors.purple,
            child: Column(
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: const Text(
                    'CareConnect',
                    style: TextStyle(
                      color: Color.fromARGB(255, 49, 43, 43),
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: Icon(Icons.arrow_back),
                        title: Text("Back"),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: Icon(Icons.badge),
                        title: Text("Employees"),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EmployeeListScreen(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.group),
                        title: Text("Clients"),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClientListScreen(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.miscellaneous_services),
                        title: Text("Services"),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClientListScreen(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.event),
                        title: Text("Appointments"),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClientListScreen(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.school),
                        title: Text("Workshops"),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClientListScreen(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.reviews),
                        title: Text("Reviews"),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClientListScreen(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.insert_chart_outlined),
                        title: Text("Report"),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClientListScreen(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text("Profile"),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClientListScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),

                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
