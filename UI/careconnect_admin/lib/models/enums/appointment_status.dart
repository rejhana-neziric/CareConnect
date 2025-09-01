import 'package:flutter/material.dart';

enum AppointmentStatus {
  scheduled,
  confirmed,
  rescheduled,
  canceled,
  started,
  completed,
}

extension AppointmentStatusStyle on AppointmentStatus {
  Color get backgroundColor {
    switch (this) {
      case AppointmentStatus.scheduled:
        return const Color(0xFFE0E0E0); // light gray
      case AppointmentStatus.confirmed:
        return const Color(0xFFD0F0DA); // soft green
      case AppointmentStatus.rescheduled:
        return const Color(0xFFFFE5B4); // light orange
      case AppointmentStatus.canceled:
        return const Color(0xFFF8D7DA); // light red
      case AppointmentStatus.started:
        return const Color(0xFFFFF3CD); // pale yellow/orange
      case AppointmentStatus.completed:
        return const Color(0xFFC8E6C9); // slightly darker green
    }
  }

  Color get textColor {
    switch (this) {
      case AppointmentStatus.scheduled:
        return Colors.black54;
      case AppointmentStatus.confirmed:
        return Colors.green.shade800;
      case AppointmentStatus.rescheduled:
        return Colors.orange.shade800;
      case AppointmentStatus.canceled:
        return Colors.red.shade800;
      case AppointmentStatus.started:
        return Colors.orange.shade900;
      case AppointmentStatus.completed:
        return Colors.green.shade900;
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
        return ['Confirm', 'Cancel'];
      case AppointmentStatus.confirmed:
        return ['Cancel', 'Start', 'Reschedule'];
      case AppointmentStatus.rescheduled:
        return ['Confirm', 'Cancel'];
      case AppointmentStatus.started:
        return ['Complete'];
      case AppointmentStatus.completed:
        return [];
      case AppointmentStatus.canceled:
        return [];
    }
  }
}
