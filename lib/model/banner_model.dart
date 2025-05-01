class BannerModel {
  final String id;
  final String imageUrl;
  final String title;
  final String link;
  final String type;

  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.link,
    required this.type,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'title': title,
    'link': link,
    'type': type,
  };
}
