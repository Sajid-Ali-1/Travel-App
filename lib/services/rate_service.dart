import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// 1. Data Model Class
class LiabilityRate {
  final double limit;
  final double sum;
  final double extended;

  LiabilityRate({
    required this.limit,
    required this.sum,
    required this.extended,
  });

  // Factory constructor to create an object from a JSON map
  factory LiabilityRate.fromJson(Map<String, dynamic> json) {
    return LiabilityRate(
      limit: json['Liability Amount'] as double,
      sum: json['Sum'] as double,
      extended: (json['Extended'] as int).toDouble(),
    );
  }
}

// 2. Service Class to Load Data
class RateService {

  Future<List<LiabilityRate>> loadRates() async {
    // Load the JSON string from assets
    final String jsonString = await rootBundle.loadString(
      'assets/rate_schedule_w30.json',
    );

    // Decode the JSON string into a List of Maps
    final List<dynamic> jsonList = jsonDecode(jsonString);

    // Convert the List of Maps into a List of LiabilityRate objects
    return jsonList
        .map((json) => LiabilityRate.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
