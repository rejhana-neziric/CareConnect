import 'package:careconnect_mobile/core/theme/theme_notifier.dart';
import 'package:careconnect_mobile/models/auth_credentials.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/screens/client_list_screen.dart';
import 'package:careconnect_mobile/screens/employee_list_screen.dart';
import 'package:careconnect_mobile/screens/home_screen.dart';
import 'package:careconnect_mobile/screens/login_screen.dart';
import 'package:careconnect_mobile/screens/my_appointments_screen.dart';
import 'package:careconnect_mobile/screens/profile/profile_screen.dart';
import 'package:careconnect_mobile/screens/review/review_list_screen.dart';
import 'package:careconnect_mobile/screens/services_list_screen.dart';
import 'package:careconnect_mobile/screens/workshops_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        backgroundColor: colorScheme.surfaceContainerLowest,
        foregroundColor: colorScheme.onSurface,
        actions: [_buildThemeToggleButton(context, themeNotifier)],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            _buildDrawerItem(
              context,
              title: "Home",
              icon: Icons.home,
              screen: const HomeScreen(),
            ),
            _buildDrawerItem(
              context,
              title: "My appointments",
              icon: Icons.event,
              screen: const MyAppointmentsScreen(),
            ),
            _buildDrawerItem(
              context,
              title: "Services",
              icon: FontAwesomeIcons.handHoldingHeart,
              screen: const ServicesListScreen(),
            ),
            _buildDrawerItem(
              context,
              title: "Workshops",
              icon: FontAwesomeIcons.puzzlePiece,
              screen: const WorkshopsListScreen(),
            ),
            _buildDrawerItem(
              context,
              title: "Profile",
              icon: Icons.account_circle,
              screen: ProfileScreen(),
            ),
            _buildDrawerItem(
              context,
              title: "My Reviews",
              icon: Icons.reviews,
              screen: ReviewListScreen(),
            ),
            _buildDrawerItem(
              context,
              title: "Employees",
              icon: Icons.people,
              screen: const EmployeeListScreen(),
            ),
            _buildDrawerItem(
              context,
              title: "Clients",
              icon: Icons.person,
              screen: const ClientListScreen(),
            ),

            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Logout"),
              onTap: () {
                AuthCredentials.username = null;
                AuthCredentials.password = null;

                final auth = Provider.of<AuthProvider>(context, listen: false);
                auth.logout();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),

            _buildThemeToggleTile(context, themeNotifier),
          ],
        ),
      ),
      body: //widget.child,
      Container(
        //color: AppColors.lightGray,
        color: colorScheme.surfaceContainerLow,
        child: widget.child,
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget screen,
  }) {
    final bool isSelected = widget.title == title;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MasterScreen(title, screen)),
        );
      },
    );
  }

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
