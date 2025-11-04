import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiBaseUrl {
    const fromDefine = String.fromEnvironment('API_BASE_URL');
    if (fromDefine.isNotEmpty) return fromDefine;
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:5241/';
  }

  static String get signalHubUrl {
    const fromDefine = String.fromEnvironment('SIGNALR_HUB_URL');
    if (fromDefine.isNotEmpty) return fromDefine;
    return dotenv.env['SIGNALR_HUB_URL'] ??
        'http://localhost:5241/notificationHub';
  }
}
