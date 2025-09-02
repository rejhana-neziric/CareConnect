import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeAvailabilityListScreen extends StatefulWidget {
  const EmployeeAvailabilityListScreen({super.key});

  @override
  State<EmployeeAvailabilityListScreen> createState() =>
      _EmployeeAvailabilityListScreenState();
}

class _EmployeeAvailabilityListScreenState
    extends State<EmployeeAvailabilityListScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // if (!(auth.user?.roles.contains('Employee') ?? false)) {
    //   return Scaffold(
    //     body: Center(
    //       child: Text(
    //         "Access denied. You do not have permission to view this.",
    //       ),
    //     ),
    //   );
    // }
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return MasterScreen(
      "Services",
      Column(children: [Placeholder()]),
      // Row(
      //   children: [
      //     Expanded(
      //       child: SingleChildScrollView(
      //         child: Column(
      //           children: [
      //             Placeholder(),
      //             // _buildOverview(),
      //             // _buildSearch(colorScheme),
      //             // Consumer<ServiceProvider>(
      //             //   builder: (context, serviceProvider, child) {
      //             //     return _buildResultView();
      //             //   },
      //             // ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     // Consumer<ServiceTypeProvider>(
      //     //   builder: (context, serviceTypeProvider, child) {
      //     //     return _buildServiceTypesList(colorScheme);
      //     //   },
      //     // ),
      //   ],
      // ),
    );
  }
}
