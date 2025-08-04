import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/service.dart';
import 'package:flutter/material.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Service? service;

  const ServiceDetailsScreen({super.key, this.service});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreen("Service Details", Placeholder());
  }
}
