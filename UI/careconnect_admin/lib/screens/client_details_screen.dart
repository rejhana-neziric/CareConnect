import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/client.dart';
import 'package:flutter/material.dart';

class ClientDetailsScreen extends StatefulWidget {
  final Client? client;

  const ClientDetailsScreen({super.key, this.client});

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Clients Details",
      // SingleChildScrollView(
      //   padding: const EdgeInsets.all(16), // optional for spacing
      //   child:
      Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Placeholder(),
          // _buildOverview(),
          // _buildSearch(),
          // Consumer<ClientProvider>(
          //   builder: (context, provider, child) {
          //     if (provider.shouldRefresh) {
          //       loadData();
          //       provider.markRefreshed();
          //     }
          //     return _buildResultView(result, loadData);
          //   },
          // ),
        ],
      ),
    );
  }
}
