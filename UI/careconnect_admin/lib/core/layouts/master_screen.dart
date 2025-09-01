import 'package:careconnect_admin/screens/appointment_list_screen.dart';
import 'package:careconnect_admin/screens/client_list_screen.dart';
import 'package:careconnect_admin/screens/employee_availability/employee_availability_details_screen.dart';
import 'package:careconnect_admin/screens/employee_availability/employee_availability_list_screen.dart';
import 'package:careconnect_admin/screens/employee_list_screen.dart';
import 'package:careconnect_admin/screens/review_list_screen.dart';
import 'package:careconnect_admin/screens/services_list_screen.dart';
import 'package:careconnect_admin/screens/workshops_list_screen.dart';
import 'package:careconnect_admin/core/theme/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: colorScheme.surfaceContainerLowest,
            child: Column(
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.center,

                  child: Text(
                    'CareConnect',
                    style: TextStyle(
                      // color: AppColors.mauveGray,
                      color: colorScheme.primary,
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
                        leading: Icon(
                          Icons.arrow_back,
                          //color: colorScheme.surfaceContainerLowest,
                        ),
                        title: Text(
                          "Back",
                          //style: TextStyle(color: colorScheme.onSurface),
                        ),

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
                        selectedTileColor: colorScheme.surfaceContainerHighest,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EmployeeListScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.badge),
                        title: Text("Employee Availability"),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EmployeeAvailabilityListScreen(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.badge),
                        title: Text("Employee Availability Details"),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EmployeeAvailabilityDetailsScreen(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.group),
                        title: Text("Clients"),
                        selectedTileColor: colorScheme.surfaceContainerHighest,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ClientListScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.miscellaneous_services),
                        title: Text("Services"),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ServicesListScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.event),
                        title: Text("Appointments"),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AppointmentListScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.school),
                        title: Text("Workshops"),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WorkshopsListScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.reviews),
                        title: Text("Reviews"),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ReviewListScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.insert_chart_outlined),
                        title: Text("Report"),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ClientListScreen(),
                            ),
                          );
                        },
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

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Divider(
                          color: colorScheme.outline.withOpacity(0.3),
                        ),
                      ),

                      _buildThemeToggleTile(context, themeNotifier),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: colorScheme.surfaceContainerLowest,
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
                            //color: AppColors.mauveGray,
                            color: colorScheme.primary,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            // Theme toggle button in header (alternative position)
                            _buildThemeToggleButton(context, themeNotifier),
                            if (widget.button != null) ...[
                              const SizedBox(width: 16),
                              widget.button!,
                            ],
                          ],
                        ),
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
                      //color: AppColors.lightGray,
                      color: colorScheme.surfaceContainerLow,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),

                        child: widget.child,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildNavTile(
  //   BuildContext context,
  //   IconData icon,
  //   String title,
  //   VoidCallback onTap,
  // ) {
  //   final colorScheme = Theme.of(context).colorScheme;

  //   return ListTile(
  //     leading: Icon(icon, color: colorScheme.onSurface),
  //     title: Text(title, style: TextStyle(color: colorScheme.onSurface)),
  //     onTap: onTap,
  //     hoverColor: colorScheme.primary.withOpacity(0.1),
  //   );
  // }

  Widget _buildThemeToggleTile(
    BuildContext context,
    ThemeNotifier themeNotifier,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    String themeText;
    IconData themeIcon;

    switch (themeNotifier.themeMode) {
      case ThemeMode.light:
        themeText = "Light Theme";
        themeIcon = Icons.light_mode;
        break;
      case ThemeMode.dark:
        themeText = "Dark Theme";
        themeIcon = Icons.dark_mode;
        break;
      case ThemeMode.system:
        themeText = "System Theme";
        themeIcon = Icons.brightness_auto;
        break;
    }

    return ListTile(
      leading: Icon(themeIcon, color: colorScheme.primary),
      title: Text(
        themeText,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: themeNotifier.toggleTheme,
      hoverColor: colorScheme.primary.withOpacity(0.1),
    );
  }

  Widget _buildThemeToggleButton(
    BuildContext context,
    ThemeNotifier themeNotifier,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    IconData icon;
    String tooltip;

    switch (themeNotifier.themeMode) {
      case ThemeMode.light:
        icon = Icons.light_mode;
        tooltip = "Switch to Dark Theme";
        break;
      case ThemeMode.dark:
        icon = Icons.dark_mode;
        tooltip = "Switch to System Theme";
        break;
      case ThemeMode.system:
        icon = Icons.brightness_auto;
        tooltip = "Switch to Light Theme";
        break;
    }

    return IconButton(
      icon: Icon(icon, color: colorScheme.primary),
      tooltip: tooltip,
      onPressed: themeNotifier.toggleTheme,
    );
  }
}
