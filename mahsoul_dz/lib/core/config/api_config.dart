import 'dart:io';

class ApiConfig {
  // Backend server base URL
  // ====== FOR TEAM MEMBERS  IMPORTANT ======
  // IMPORTANT: If you're using a PHYSICAL Android device (not emulator),
  // you need to change this to your computer's IP address.
  // Find your IP: Windows: ipconfig | findstr IPv4
  // Example: 'http://192.168.1.100:5000/api'
  //
  // For Android emulator: 10.0.2.2 maps to host machine's localhost
  // For iOS simulator: localhost works fine
  // For physical Android device: Use your computer's local IP (e.g., 192.168.1.100)
  
  // Set this to your computer's IP if using a physical Android device
  // Leave empty to use default (10.0.2.2 for emulator, localhost for iOS)
  static const String manualIpOverride = '172.20.10.3'; // e.g., '192.168.1.100'
  
  static String get baseUrl {
    if (manualIpOverride.isNotEmpty) {
      final url = 'http://$manualIpOverride:5000/api';
      print('🌐 Using manual IP override: $url');
      return url;
    }
    
    if (Platform.isAndroid) {
      final url = 'http://10.0.2.2:5000/api';
      print('🌐 Android detected - Using emulator IP: $url');
      print('   💡 If using a physical device, set manualIpOverride in api_config.dart');
      return url;
    } else if (Platform.isIOS) {
      final url = 'http://localhost:5000/api';
      print('🌐 iOS detected - Using localhost: $url');
      return url;
    } else {
      final url = 'http://localhost:5000/api';
      print('🌐 Other platform - Using localhost: $url');
      return url;
    }
  }
  
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

