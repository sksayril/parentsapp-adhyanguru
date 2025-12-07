class ApiConfig {
  // Base API URL
  // Using dev tunnel URL for all platforms
  // For Physical Device: If localhost doesn't work, uncomment and set your computer's IP:
  // static const String? customIp = '192.168.1.100'; // Replace with your computer's IP
  
  static String get baseUrl {
    // Uncomment the line below and set your IP for physical device testing
    // if (customIp != null) return 'http://$customIp:3000';
    
    // Use dev tunnel URL for all platforms
    return 'https://7cvccltb-3000.inc1.devtunnels.ms';
  }
  
  // Helper method to get the current base URL (for debugging)
  static String get currentBaseUrl => baseUrl;
}
