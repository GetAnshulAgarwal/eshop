class Offer {
  final String title;
  final List<String> imageUrls; // exactly 4 items
  final int moreCount;

  Offer({
    required this.title,
    required this.imageUrls,
    required this.moreCount,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    title: json['title'] as String,
    imageUrls: List<String>.from(json['images']),
    moreCount: json['more_count'] as int,
  );
}
