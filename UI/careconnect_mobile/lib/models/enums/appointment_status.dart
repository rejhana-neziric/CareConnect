import 'package:flutter/material.dart';

enum AppointmentStatus {
  scheduled,
  confirmed,
  rescheduled,
  reschedulerequested,
  reschedulependingapproval,
  canceled,
  started,
  completed,
}

extension AppointmentStatusStyle on AppointmentStatus {
  Color get backgroundColor {
    switch (this) {
      case AppointmentStatus.scheduled:
        return const Color(0xFFE3F2FD); // light blue
      case AppointmentStatus.confirmed:
        return const Color(0xFFD0F0DA); // soft green
      case AppointmentStatus.rescheduled:
        return const Color(0xFFFFF3E0); // soft orange-beige
      case AppointmentStatus.reschedulerequested:
        return const Color(0xFFFFF3E0); // soft orange-beige
      case AppointmentStatus.reschedulependingapproval:
        return const Color(0xFFFFF3E0); // soft orange-beige
      case AppointmentStatus.canceled:
        return const Color(0xFFFFEBEE); // light red/pink
      case AppointmentStatus.started:
        return const Color(0xFFFFF8E1); // pale yellow
      case AppointmentStatus.completed:
        return const Color(0xFFE8F5E9); // soft success green
    }
  }

  Color get textColor {
    switch (this) {
      case AppointmentStatus.scheduled:
        return Colors.blue.shade800; // stronger blue
      case AppointmentStatus.confirmed:
        return Colors.green.shade800; // deep green
      case AppointmentStatus.rescheduled:
        return Colors.orange.shade800; // medium orange
      case AppointmentStatus.reschedulerequested:
        return Colors.orange.shade900; // darker orange
      case AppointmentStatus.reschedulependingapproval:
        return Colors.deepOrange.shade800; // deeper orange-red
      case AppointmentStatus.canceled:
        return Colors.red.shade800; // strong red
      case AppointmentStatus.started:
        return Colors.amber.shade900; // deep amber
      case AppointmentStatus.completed:
        return Colors.teal.shade800; // calm dark green/teal
    }
  }

  String get label {
    switch (this) {
      case AppointmentStatus.scheduled:
        return "Scheduled";
      case AppointmentStatus.confirmed:
        return "Confirmed";
      case AppointmentStatus.rescheduled:
        return "Rescheduled";
      case AppointmentStatus.reschedulerequested:
        return "Requested Reschedule";
      case AppointmentStatus.reschedulependingapproval:
        return "Reschedule Pending Approval";
      case AppointmentStatus.canceled:
        return "Canceled";
      case AppointmentStatus.started:
        return "Started";
      case AppointmentStatus.completed:
        return "Completed";
    }
  }
}

AppointmentStatus appointmentStatusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'scheduled':
      return AppointmentStatus.scheduled;
    case 'confirmed':
      return AppointmentStatus.confirmed;
    case 'rescheduled':
      return AppointmentStatus.rescheduled;
    case 'reschedulerequested':
      return AppointmentStatus.reschedulerequested;
    case 'reschedulePendingApproval':
      return AppointmentStatus.reschedulependingapproval;
    case 'canceled':
      return AppointmentStatus.canceled;
    case 'started':
      return AppointmentStatus.started;
    case 'completed':
      return AppointmentStatus.completed;
    default:
      return AppointmentStatus.scheduled; // fallback
  }
}

extension AppointmentStatusActions on AppointmentStatus {
  List<String> get allowedActions {
    switch (this) {
      case AppointmentStatus.scheduled:
        return ['Cancel'];
      case AppointmentStatus.confirmed:
        return ['Cancel'];
      case AppointmentStatus.rescheduled:
        return ['Cancel'];
      case AppointmentStatus.reschedulerequested:
        return ['Cancel', 'Choose new time'];
      case AppointmentStatus.reschedulependingapproval:
        return ['Cancel'];
      case AppointmentStatus.started:
        return [];
      case AppointmentStatus.completed:
        return [];
      case AppointmentStatus.canceled:
        return [];
    }
  }
}
