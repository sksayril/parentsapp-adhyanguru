import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/session_manager.dart';
import '../config/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;
  
  // Get headers with authentication token
  static Future<Map<String, String>> _getHeaders({
    bool includeAuth = false,
    bool isMultipart = false,
  }) async {
    Map<String, String> headers = {};
    
    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }
    
    if (includeAuth) {
      final token = await SessionManager.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }

  // Parent Signup
  // studentId format: ADSTD#### (e.g., ADSTD0018, ADSTD0001)
  static Future<Map<String, dynamic>> parentSignup({
    required String name,
    required String email,
    required String password,
    required String contactNumber,
    String? studentId, // Format: ADSTD#### (e.g., ADSTD0018, ADSTD0001)
    File? profileImage,
  }) async {
    try {
      // Debug: Print the base URL being used
      print('API Base URL: $baseUrl');
      final uri = Uri.parse('$baseUrl/api/parents/signup');
      print('Signup URL: $uri');
      var request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields['name'] = name.trim();
      request.fields['email'] = email.trim().toLowerCase();
      request.fields['password'] = password;
      request.fields['contactNumber'] = contactNumber.trim();
      
      if (studentId != null && studentId.isNotEmpty) {
        request.fields['studentId'] = studentId.trim();
      }

      // Add profile image if provided
      if (profileImage != null) {
        final fileExtension = profileImage.path.split('.').last.toLowerCase();
        final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
        
        if (!allowedExtensions.contains(fileExtension)) {
          return {
            'success': false,
            'message': 'Only image files are allowed (jpg, jpeg, png, gif, webp)',
          };
        }

        // Check file size (5MB = 5 * 1024 * 1024 bytes)
        final fileSize = await profileImage.length();
        if (fileSize > 5 * 1024 * 1024) {
          return {
            'success': false,
            'message': 'File too large. Maximum size is 5MB.',
          };
        }

        request.files.add(
          await http.MultipartFile.fromPath(
            'profileImage',
            profileImage.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        // Store token if signup is successful
        if (responseData['data'] != null && responseData['data']['token'] != null) {
          await SessionManager.saveToken(responseData['data']['token']);
          await SessionManager.saveUserData(responseData['data']);
        }
        return {
          'success': true,
          'message': responseData['message'] ?? 'Parent registered successfully',
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Signup failed',
          'errors': responseData['errors'] ?? [],
        };
      }
    } catch (e) {
      String errorMessage = 'Network error. Please check your connection.';
      
      // Provide more specific error messages
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('SocketException')) {
        errorMessage = 'Cannot connect to server. Please ensure:\n'
            '1. Server is running on port 3000\n'
            '2. For Android Emulator: Server should be accessible at http://10.0.2.2:3000\n'
            '3. For Physical Device: Use your computer\'s IP address\n'
            '4. Check your network connection';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Request timeout. Server is taking too long to respond.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    }
  }

  // Parent Login
  // POST /api/parents/login
  // Authentication: Not required
  // Request: { "email": "string", "password": "string" }
  // Response: { "success": true, "message": "string", "data": { "token": "string", ... } }
  static Future<Map<String, dynamic>> parentLogin({
    required String email,
    required String password,
  }) async {
    try {
      // Debug: Print the base URL being used
      print('API Base URL: $baseUrl');
      // Login doesn't require authentication, so we don't include auth headers
      final headers = await _getHeaders(includeAuth: false);
      final uri = Uri.parse('$baseUrl/api/parents/login');
      print('Login URL: $uri');
      
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          'email': email.trim().toLowerCase(), // Auto lowercase and trim as per API spec
          'password': password, // Password validation: 6-128 chars (handled in form)
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Store token if login is successful
        if (responseData['data'] != null && responseData['data']['token'] != null) {
          await SessionManager.saveToken(responseData['data']['token']);
          await SessionManager.saveUserData(responseData['data']);
        }
        return {
          'success': true,
          'message': responseData['message'] ?? 'Login successful',
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
          'errors': responseData['errors'] ?? [],
        };
      }
    } catch (e) {
      String errorMessage = 'Network error. Please check your connection.';
      
      // Provide more specific error messages
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('SocketException')) {
        errorMessage = 'Cannot connect to server. Please ensure:\n'
            '1. Server is running on port 3000\n'
            '2. For Android Emulator: Server should be accessible at http://10.0.2.2:3000\n'
            '3. For Physical Device: Use your computer\'s IP address\n'
            '4. Check your network connection';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Request timeout. Server is taking too long to respond.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    }
  }

  // Get Dashboard Data
  static Future<Map<String, dynamic>> getDashboard({
    String period = '30d', // Default to 30 days
  }) async {
    try {
      // Debug: Print the base URL being used
      print('API Base URL: $baseUrl');
      final headers = await _getHeaders(includeAuth: true);
      final uri = Uri.parse('$baseUrl/api/parents/dashboard').replace(
        queryParameters: {'period': period},
      );
      print('Dashboard URL: $uri');
      
      final response = await http.get(
        uri,
        headers: headers,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Dashboard retrieved successfully',
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch dashboard',
          'errors': responseData['errors'] ?? [],
        };
      }
    } catch (e) {
      String errorMessage = 'Network error. Please check your connection.';
      
      // Provide more specific error messages
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('SocketException')) {
        errorMessage = 'Cannot connect to server. Please ensure:\n'
            '1. Server is running\n'
            '2. Check your network connection\n'
            '3. Verify you are logged in';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Request timeout. Server is taking too long to respond.';
      } else if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    }
  }

  // Get My Children List
  static Future<Map<String, dynamic>> getMyChildrenList() async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final uri = Uri.parse('$baseUrl/api/parents/my-children/list');
      print('Get Children List URL: $uri');
      
      final response = await http.get(
        uri,
        headers: headers,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Children list retrieved successfully',
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch children list',
          'errors': responseData['errors'] ?? [],
        };
      }
    } catch (e) {
      String errorMessage = 'Network error. Please check your connection.';
      
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('SocketException')) {
        errorMessage = 'Cannot connect to server. Please ensure:\n'
            '1. Server is running\n'
            '2. Check your network connection\n'
            '3. Verify you are logged in';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Request timeout. Server is taking too long to respond.';
      } else if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    }
  }

  // Get Child Progress
  static Future<Map<String, dynamic>> getChildProgress({
    required String childId,
    String period = '30d',
    String? courseId,
    String? batchId,
  }) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final queryParams = <String, String>{
        'period': period,
      };
      if (courseId != null && courseId.isNotEmpty) {
        queryParams['courseId'] = courseId;
      }
      if (batchId != null && batchId.isNotEmpty) {
        queryParams['batchId'] = batchId;
      }
      
      final uri = Uri.parse('$baseUrl/api/parents/my-children/$childId/progress')
          .replace(queryParameters: queryParams);
      print('Get Child Progress URL: $uri');
      
      final response = await http.get(
        uri,
        headers: headers,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Child progress retrieved successfully',
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch child progress',
          'errors': responseData['errors'] ?? [],
        };
      }
    } catch (e) {
      String errorMessage = 'Network error. Please check your connection.';
      
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('SocketException')) {
        errorMessage = 'Cannot connect to server. Please ensure:\n'
            '1. Server is running\n'
            '2. Check your network connection\n'
            '3. Verify you are logged in';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Request timeout. Server is taking too long to respond.';
      } else if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        errorMessage = 'You do not have access to this child\'s data.';
      } else if (e.toString().contains('404') || e.toString().contains('Not Found')) {
        errorMessage = 'Child not found.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    }
  }

  // Get All My Children Activities
  static Future<Map<String, dynamic>> getAllChildrenActivities({
    int limit = 20,
    int page = 1,
    String? eventType,
    String? courseId,
    String? batchId,
  }) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final queryParams = <String, String>{
        'limit': limit.toString(),
        'page': page.toString(),
      };
      if (eventType != null && eventType.isNotEmpty) {
        queryParams['eventType'] = eventType;
      }
      if (courseId != null && courseId.isNotEmpty) {
        queryParams['courseId'] = courseId;
      }
      if (batchId != null && batchId.isNotEmpty) {
        queryParams['batchId'] = batchId;
      }
      
      final uri = Uri.parse('$baseUrl/api/parents/my-children/activities')
          .replace(queryParameters: queryParams);
      print('Get All Activities URL: $uri');
      
      final response = await http.get(
        uri,
        headers: headers,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'All children activities retrieved successfully',
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch activities',
          'errors': responseData['errors'] ?? [],
        };
      }
    } catch (e) {
      String errorMessage = 'Network error. Please check your connection.';
      
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('SocketException')) {
        errorMessage = 'Cannot connect to server. Please ensure:\n'
            '1. Server is running\n'
            '2. Check your network connection\n'
            '3. Verify you are logged in';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Request timeout. Server is taking too long to respond.';
      } else if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    }
  }

  // Get Parent Profile
  static Future<Map<String, dynamic>> getParentProfile() async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final uri = Uri.parse('$baseUrl/api/parents/profile');
      print('Get Parent Profile URL: $uri');
      
      final response = await http.get(
        uri,
        headers: headers,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Parent profile retrieved successfully',
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch profile',
          'errors': responseData['errors'] ?? [],
        };
      }
    } catch (e) {
      String errorMessage = 'Network error. Please check your connection.';
      
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('SocketException')) {
        errorMessage = 'Cannot connect to server. Please ensure:\n'
            '1. Server is running\n'
            '2. Check your network connection\n'
            '3. Verify you are logged in';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Request timeout. Server is taking too long to respond.';
      } else if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    }
  }

  // AI Counseling - Get AI Response
  // POST https://api.a0.dev/ai/llm
  // Request: { "messages": [{ "role": "user", "content": "string" }] }
  // Response: { "completion": "string" }
  static Future<Map<String, dynamic>> getAIResponse(String prompt) async {
    try {
      final uri = Uri.parse('https://api.a0.dev/ai/llm');
      print('AI API URL: $uri');
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'completion': responseData['completion'] ?? '',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to get AI response',
          'error': responseData.toString(),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please check your connection.',
        'error': e.toString(),
      };
    }
  }

  // Logout
  static Future<void> logout() async {
    await SessionManager.clearSession();
  }
}

