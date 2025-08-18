import 'package:flutter/material.dart';

enum WorkshopStatus { draft, published, closed, canceled }

extension WorkshopStatusStyle on WorkshopStatus {
  Color get backgroundColor {
    switch (this) {
      case WorkshopStatus.draft:
        return const Color.fromRGBO(230, 230, 230, 1); // gray
      case WorkshopStatus.published:
        return const Color.fromRGBO(204, 245, 215, 1); // green
      case WorkshopStatus.closed:
        return const Color.fromRGBO(255, 230, 200, 1); // orange
      case WorkshopStatus.canceled:
        return const Color.fromRGBO(255, 200, 200, 1); // red
    }
  }

  Color get textColor {
    switch (this) {
      case WorkshopStatus.draft:
        return Colors.black54;
      case WorkshopStatus.published:
        return Colors.black87;
      case WorkshopStatus.closed:
        return Colors.orange.shade800;
      case WorkshopStatus.canceled:
        return Colors.red.shade700;
    }
  }

  String get label {
    switch (this) {
      case WorkshopStatus.draft:
        return "Draft";
      case WorkshopStatus.published:
        return "Published";
      case WorkshopStatus.closed:
        return "Closed";
      case WorkshopStatus.canceled:
        return "Canceled";
    }
  }
}

WorkshopStatus workshopStatusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'draft':
      return WorkshopStatus.draft;
    case 'published':
      return WorkshopStatus.published;
    case 'closed':
      return WorkshopStatus.closed;
    case 'canceled':
      return WorkshopStatus.canceled;
    default:
      return WorkshopStatus.draft; // fallback
  }
}
