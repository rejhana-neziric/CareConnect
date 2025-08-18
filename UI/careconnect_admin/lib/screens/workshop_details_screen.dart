import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/workshop.dart';
import 'package:flutter/material.dart';

class WorkshopDetailsScreen extends StatefulWidget {
  final Workshop? workshop;

  const WorkshopDetailsScreen({super.key, this.workshop});

  @override
  State<WorkshopDetailsScreen> createState() => _WorkshopDetailsScreenState();
}

class _WorkshopDetailsScreenState extends State<WorkshopDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Workshop Details",
      SingleChildScrollView(
        padding: const EdgeInsets.all(64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // if (!isLoading) _buildForm(),
                    // const SizedBox(height: 20),
                    // _actionButtons(),
                    Placeholder(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // onBackPressed: () => serviceFormProvider.handleBackPressed(context),
    );
  }
}
