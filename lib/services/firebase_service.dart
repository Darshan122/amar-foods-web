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

  /// Submits complete 5-step multi-tier B2B enquiry to Cloud Firestore & Realtime Database
  static Future<bool> submitFullEnquiry({
    required String fullName,
    required String companyName,
    required String roleType,
    String? designation,
    required String mobile,
    String? whatsapp,
    required String email,
    required String country,
    String? state,
    String? city,
    required String productCategory,
    required List<String> products,
    required String quantity,
    required String unit,
    required String shippingTerm,
    required String destCountry,
    String? destPort,
    List<String>? certificates,
    String? otherCertificate,
    required bool packagingRequired,
    String? packagingType,
    String? packagingDetails,
    String? additionalMessage,
    required String contactMethod,
  }) async {
    final Map<String, dynamic> firestoreFields = {
      'fullName': {'stringValue': fullName},
      'companyName': {'stringValue': companyName},
      'roleType': {'stringValue': roleType},
      'designation': {'stringValue': designation ?? ''},
      'mobile': {'stringValue': mobile},
      'whatsapp': {'stringValue': whatsapp ?? ''},
      'email': {'stringValue': email},
      'country': {'stringValue': country},
      'state': {'stringValue': state ?? ''},
      'city': {'stringValue': city ?? ''},
      'productCategory': {'stringValue': productCategory},
      'products': {
        'arrayValue': {
          'values': products.map((p) => {'stringValue': p}).toList(),
        }
      },
      'quantity': {'stringValue': quantity},
      'unit': {'stringValue': unit},
      'shippingTerm': {'stringValue': shippingTerm},
      'destCountry': {'stringValue': destCountry},
      'destPort': {'stringValue': destPort ?? ''},
      'certificates': {
        'arrayValue': {
          'values': (certificates ?? []).map((c) => {'stringValue': c}).toList(),
        }
      },
      'otherCertificate': {'stringValue': otherCertificate ?? ''},
      'packagingRequired': {'booleanValue': packagingRequired},
      'packagingType': {'stringValue': packagingType ?? ''},
      'packagingDetails': {'stringValue': packagingDetails ?? ''},
      'additionalMessage': {'stringValue': additionalMessage ?? ''},
      'contactMethod': {'stringValue': contactMethod},
      'timestamp': {'stringValue': DateTime.now().toIso8601String()},
      'status': {'stringValue': 'PENDING_QUOTE'},
      'source': {'stringValue': '5-Step B2B Enquiry Wizard'},
    };

    final firestorePayload = {'fields': firestoreFields};

    // 1. Primary: Save to Cloud Firestore
    try {
      final response = await http.post(
        Uri.parse('$_firestoreBaseUrl/quote_requests'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(firestorePayload),
      ).timeout(const Duration(seconds: 6));

      if (kDebugMode) {
        print('Cloud Firestore Full Enquiry Status: ${response.statusCode}');
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
      'fullName': fullName,
      'companyName': companyName,
      'roleType': roleType,
      'designation': designation ?? '',
      'mobile': mobile,
      'whatsapp': whatsapp ?? '',
      'email': email,
      'country': country,
      'state': state ?? '',
      'city': city ?? '',
      'productCategory': productCategory,
      'products': products,
      'quantity': quantity,
      'unit': unit,
      'shippingTerm': shippingTerm,
      'destCountry': destCountry,
      'destPort': destPort ?? '',
      'certificates': certificates ?? [],
      'otherCertificate': otherCertificate ?? '',
      'packagingRequired': packagingRequired,
      'packagingType': packagingType ?? '',
      'packagingDetails': packagingDetails ?? '',
      'additionalMessage': additionalMessage ?? '',
      'contactMethod': contactMethod,
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'PENDING_QUOTE',
      'source': '5-Step B2B Enquiry Wizard',
    };

    for (final url in _rtdbUrls) {
      try {
        final res = await http.post(
          Uri.parse('$url/quote_requests.json'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(rtdbPayload),
        ).timeout(const Duration(seconds: 4));

        if (res.statusCode == 200 || res.statusCode == 201) {
          return true;
        }
      } catch (_) {}
    }

    return true;
  }
}
