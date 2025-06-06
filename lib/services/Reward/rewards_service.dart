// services/rewards_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../model/Reward/reward_model.dart';

class RewardsService {
  Future<RewardsData> getRewards() async {
    try {
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 800));

      // Load JSON from asset
      final String response = await rootBundle.loadString(
        'assets/data/rewards_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(response);

      return RewardsData.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to load rewards: $e');
    }
  }
}
