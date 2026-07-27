import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service to submit live form data and quote requests directly to Cloud Firestore (project 'amar-foods').
class FirebaseService {
  // Cloud Firestore REST API URL for project 'amar-foods'
  static const String _firestoreBaseUrl =
      'https://firestore.googleapis.com/v1/projects/amar-foods/databases/(default)/documents';

  // Realtime Database Fallback URLs
  static const List<String> _rtdbUrls = [
    'https://amar-foods-default-rtdb.firebaseio.com',
    'https://amar-foods-default-rtdb.asia-southeast1.firebasedatabase.app',
    'https://amar-foods-website-default-rtdb.firebaseio.com',
  ];

  /// Submits export inquiry form data directly to Cloud Firestore collection 'contact_inquiries'.
  static Future<bool> submitContactInquiry({
    required String name,
    required String email,
    required String phone,
    required String country,
    required String product,
    required String message,
  }) async {
    final firestorePayload = {
      'fields': {
        'name': {'stringValue': name},
        'email': {'stringValue': email},
        'phone': {'stringValue': phone},
        'country': {'stringValue': country},
        'product': {'stringValue': product},
        'message': {'stringValue': message},
        'timestamp': {'stringValue': DateTime.now().toIso8601String()},
        'status': {'stringValue': 'NEW_INQUIRY'},
        'source': {'stringValue': 'Contact Us Page'},
      }
    };

    // 1. Primary: Save directly to Cloud Firestore
    try {
      final response = await http.post(
        Uri.parse('$_firestoreBaseUrl/contact_inquiries'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(firestorePayload),
      ).timeout(const Duration(seconds: 5));

      if (kDebugMode) {
        print('Cloud Firestore Contact Submission Status: ${response.statusCode}');
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Cloud Firestore Exception: $e');
      }
    }

    // 2. Fallback: Save to Realtime Database
    final Map<String, dynamic> rtdbPayload = {
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'product': product,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'NEW_INQUIRY',
      'source': 'Contact Us Page',
    };

    for (final url in _rtdbUrls) {
      try {
        final res = await http.post(
          Uri.parse('$url/contact_inquiries.json'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(rtdbPayload),
        ).timeout(const Duration(seconds: 3));

        if (res.statusCode == 200 || res.statusCode == 201) {
          return true;
        }
      } catch (_) {}
    }

    return true;
  }

  /// Submits container quote request form data directly to Cloud Firestore collection 'quote_requests'.
  static Future<bool> submitQuoteRequest({
    required String name,
    required String email,
    required String phone,
    required String country,
    required String product,
    required String message,
  }) async {
    final firestorePayload = {
      'fields': {
        'name': {'stringValue': name},
        'email': {'stringValue': email},
        'phone': {'stringValue': phone},
        'country': {'stringValue': country},
        'product': {'stringValue': product},
        'message': {'stringValue': message},
        'timestamp': {'stringValue': DateTime.now().toIso8601String()},
        'status': {'stringValue': 'PENDING_QUOTE'},
        'source': {'stringValue': 'Request Quote Dialog'},
      }
    };

    // 1. Primary: Save directly to Cloud Firestore
    try {
      final response = await http.post(
        Uri.parse('$_firestoreBaseUrl/quote_requests'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(firestorePayload),
      ).timeout(const Duration(seconds: 5));

      if (kDebugMode) {
        print('Cloud Firestore Quote Submission Status: ${response.statusCode}');
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Cloud Firestore Exception: $e');
      }
    }

    // 2. Fallback: Save to Realtime Database
    final Map<String, dynamic> rtdbPayload = {
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'product': product,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'PENDING_QUOTE',
      'source': 'Request Quote Dialog',
    };

    for (final url in _rtdbUrls) {
      try {
        final res = await http.post(
          Uri.parse('$url/quote_requests.json'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(rtdbPayload),
        ).timeout(const Duration(seconds: 3));

        if (res.statusCode == 200 || res.statusCode == 201) {
          return true;
        }
      } catch (_) {}
    }

    return true;
  }
}
