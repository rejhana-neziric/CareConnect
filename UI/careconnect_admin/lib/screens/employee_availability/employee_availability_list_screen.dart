import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:flutter/material.dart';

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
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return MasterScreen(
      "Services",
      Expanded(child: Placeholder()),
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
