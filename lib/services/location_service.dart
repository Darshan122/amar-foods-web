import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CountryData {
  final String name;
  final List<String> states;

  CountryData({required this.name, required this.states});

  factory CountryData.fromJson(Map<String, dynamic> json) {
    final rawStates = json['states'] as List<dynamic>? ?? [];
    final stateNames = rawStates
        .map((s) => s is Map ? (s['name'] ?? '').toString() : s.toString())
        .where((s) => s.isNotEmpty)
        .toList();
    stateNames.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return CountryData(
      name: (json['name'] ?? '').toString(),
      states: stateNames,
    );
  }
}

class LocationService {
  static final LocationService instance = LocationService._internal();
  LocationService._internal();

  List<CountryData>? _cachedCountries;
  final Map<String, List<String>> _cachedCities = {};

  // Standard fallback list of prominent export destinations in case API is unreachable
  static final List<CountryData> _fallbackCountries = [
    CountryData(
      name: 'India',
      states: [
        'Gujarat',
        'Maharashtra',
        'Delhi',
        'Rajasthan',
        'Punjab',
        'Madhya Pradesh',
        'Tamil Nadu',
        'Karnataka',
        'Uttar Pradesh',
        'West Bengal',
        'Andhra Pradesh',
        'Haryana',
      ],
    ),
    CountryData(
      name: 'United States',
      states: [
        'California',
        'Texas',
        'Florida',
        'New York',
        'Illinois',
        'Pennsylvania',
        'Ohio',
        'Georgia',
        'North Carolina',
        'Michigan',
        'New Jersey',
        'Washington',
      ],
    ),
    CountryData(
      name: 'United Arab Emirates',
      states: [
        'Abu Dhabi',
        'Dubai',
        'Sharjah',
        'Ajman',
        'Umm Al Quwain',
        'Ras Al Khaimah',
        'Fujairah',
      ],
    ),
    CountryData(
      name: 'Saudi Arabia',
      states: [
        'Riyadh',
        'Makkah',
        'Eastern Province',
        'Madinah',
        'Asir',
        'Tabuk',
        'Qassim',
      ],
    ),
    CountryData(
      name: 'United Kingdom',
      states: [
        'England',
        'Scotland',
        'Wales',
        'Northern Ireland',
      ],
    ),
    CountryData(
      name: 'Germany',
      states: [
        'Bavaria',
        'Baden-Württemberg',
        'North Rhine-Westphalia',
        'Hesse',
        'Lower Saxony',
        'Berlin',
        'Hamburg',
      ],
    ),
    CountryData(
      name: 'Canada',
      states: [
        'Ontario',
        'Quebec',
        'British Columbia',
        'Alberta',
        'Manitoba',
        'Saskatchewan',
      ],
    ),
    CountryData(
      name: 'Australia',
      states: [
        'New South Wales',
        'Victoria',
        'Queensland',
        'Western Australia',
        'South Australia',
        'Tasmania',
      ],
    ),
    CountryData(
      name: 'Singapore',
      states: ['Central Region', 'East Region', 'North Region', 'West Region'],
    ),
    CountryData(
      name: 'Malaysia',
      states: ['Selangor', 'Johor', 'Penang', 'Kuala Lumpur', 'Perak', 'Sabah'],
    ),
    CountryData(
      name: 'South Africa',
      states: ['Gauteng', 'Western Cape', 'KwaZulu-Natal', 'Eastern Cape'],
    ),
    CountryData(
      name: 'Netherlands',
      states: ['North Holland', 'South Holland', 'Utrecht', 'North Brabant'],
    ),
    CountryData(
      name: 'Bangladesh',
      states: ['Dhaka', 'Chittagong', 'Rajshahi', 'Khulna', 'Sylhet'],
    ),
    CountryData(
      name: 'Sri Lanka',
      states: ['Western Province', 'Central Province', 'Southern Province'],
    ),
    CountryData(
      name: 'Vietnam',
      states: ['Hanoi', 'Ho Chi Minh City', 'Da Nang', 'Hai Phong'],
    ),
  ];

  /// Fetches all countries with states from CountriesNow API
  Future<List<CountryData>> getCountriesAndStates() async {
    if (_cachedCountries != null && _cachedCountries!.isNotEmpty) {
      return _cachedCountries!;
    }

    try {
      final response = await http
          .get(
            Uri.parse('https://countriesnow.space/api/v0.1/countries/states'),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['error'] == false && decoded['data'] is List) {
          final list = (decoded['data'] as List)
              .map((item) => CountryData.fromJson(item as Map<String, dynamic>))
              .where((c) => c.name.isNotEmpty)
              .toList();

          list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

          _cachedCountries = list;
          return list;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching countries from API: $e. Using fallback list.');
      }
    }

    _cachedCountries = _fallbackCountries;
    return _fallbackCountries;
  }

  /// Fetches cities for a given country and state
  Future<List<String>> getCities(String country, String state) async {
    final cacheKey = '$country|$state';
    if (_cachedCities.containsKey(cacheKey)) {
      return _cachedCities[cacheKey]!;
    }

    try {
      final response = await http
          .post(
            Uri.parse('https://countriesnow.space/api/v0.1/countries/state/cities'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'country': country,
              'state': state,
            }),
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['error'] == false && decoded['data'] is List) {
          final cities = (decoded['data'] as List)
              .map((c) => c.toString())
              .where((c) => c.trim().isNotEmpty)
              .toList();

          cities.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
          _cachedCities[cacheKey] = cities;
          return cities;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching cities for $country, $state: $e');
      }
    }

    // Default fallback if state is Gujarat
    if (country.toLowerCase() == 'india' && state.toLowerCase().contains('gujarat')) {
      final defaultCities = [
        'Mahuva',
        'Bhavnagar',
        'Ahmedabad',
        'Surat',
        'Rajkot',
        'Vadodara',
        'Junagadh',
        'Gandhidham',
        'Mundra',
        'Pipavav',
        'Jamnagar',
        'Anand',
        'Navsari',
      ];
      _cachedCities[cacheKey] = defaultCities;
      return defaultCities;
    }

    return [];
  }
}
