// models/reward_model.dart
class RewardModel {
  final String id;
  final String title;
  final String detail;
  final String companyName;
  final int expiryDays;
  final String imageUrl;
  final String status;
  final List<String> howToClaim;
  final String termsConditions;
  final String rewardCode; // Add reward code field

  RewardModel({
    required this.id,
    required this.title,
    required this.detail,
    required this.companyName,
    required this.expiryDays,
    required this.imageUrl,
    required this.status,
    required this.howToClaim,
    required this.termsConditions,
    required this.rewardCode, // Add to constructor
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'],
      title: json['title'],
      detail: json['detail'],
      companyName: json['company_name'],
      expiryDays: json['expiry_days'],
      imageUrl: json['image_url'],
      status: json['status'],
      howToClaim: List<String>.from(json['how_to_claim']),
      termsConditions: json['terms_conditions'],
      rewardCode: json['reward_code'], // Parse from JSON
    );
  }
}

class SponsoredAd {
  final String title;
  final String description;
  final String imageUrl;
  final String backgroundColor;
  final String actionUrl;

  SponsoredAd({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.backgroundColor,
    required this.actionUrl,
  });

  factory SponsoredAd.fromJson(Map<String, dynamic> json) {
    return SponsoredAd(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      backgroundColor: json['background_color'],
      actionUrl: json['action_url'],
    );
  }
}

class RewardsData {
  final int totalRewards;
  final String currencySymbol;
  final SponsoredAd sponsoredAd;
  final List<RewardModel> rewards;

  RewardsData({
    required this.totalRewards,
    required this.currencySymbol,
    required this.sponsoredAd,
    required this.rewards,
  });

  factory RewardsData.fromJson(Map<String, dynamic> json) {
    return RewardsData(
      totalRewards: json['total_rewards'],
      currencySymbol: json['currency_symbol'],
      sponsoredAd: SponsoredAd.fromJson(json['sponsored_ad']),
      rewards:
          (json['rewards'] as List)
              .map((reward) => RewardModel.fromJson(reward))
              .toList(),
    );
  }
}
