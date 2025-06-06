// services/referral_service.dart
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class ReferralService {
  static const String _referralCodeKey = 'user_referral_code';

  // Get the user's referral code (generate if doesn't exist)
  static Future<String> getReferralCode() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if a referral code already exists
    String? code = prefs.getString(_referralCodeKey);

    if (code == null) {
      // Generate a new code if none exists
      code = _generateCode();
      await prefs.setString(_referralCodeKey, code);
    }

    return code;
  }

  // Generate a random referral code
  static String _generateCode() {
    const String prefix = 'GOWREF';
    final random = Random();

    // Generate 3 random numbers and 2 random uppercase letters
    final numbers = List.generate(3, (_) => random.nextInt(10)).join();

    // Return the combined code
    return '$prefix$numbers';
  }

  // Reset referral code (for testing)
  static Future<void> resetReferralCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_referralCodeKey);
  }
}
