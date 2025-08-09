import 'package:careconnect_admin/screens/client_list_screen.dart';
import 'package:careconnect_admin/screens/employee_list_screen.dart';
import 'package:careconnect_admin/screens/services_list_screen.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen(
    this.title,
    this.child, {
    super.key,
    this.button,
    this.onBackPressed,
  });

  final String title;
  final Widget child;
  final Widget? button;
  final Future<bool> Function()? onBackPressed;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    //final appColors = Theme.of(context).extension<AppColors>()!;
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: AppColors.white,
            child: Column(
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: const Text(
                    'CareConnect',
                    style: TextStyle(
                      color: AppColors.mauveGray,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
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

                        //onTap: () => Navigator.pop(context),
                        onTap: () async {
                          if (widget.onBackPressed != null) {
                            final shouldPop = await widget.onBackPressed!();
                            if (shouldPop) {
                              Navigator.of(context).pop(true);
                            }
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
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
                            builder: (context) => ServicesListScreen(),
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
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 32.0,
                    right: 32.0,
                    bottom: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: AppColors.mauveGray,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      if (widget.button != null) ...[
                        const SizedBox(width: 8),
                        widget.button!,
                      ],
                    ],
                  ),

                  // child: Text(
                  //   widget.title,
                  //   style: TextStyle(
                  //     color: AppColors.mauveGray,
                  //     fontSize: 25,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.lightGray,
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
