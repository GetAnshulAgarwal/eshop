class RouteProgress {
  final double currentProgress; // Value between 0.0 and 1.0
  final String startTime;
  final String distance;

  RouteProgress({
    required this.currentProgress,
    required this.startTime,
    required this.distance,
  });

  factory RouteProgress.fromJson(Map<String, dynamic> json) {
    return RouteProgress(
      currentProgress: double.parse(json['progress'].toString()),
      startTime: json['startTime'],
      distance: json['distance'],
    );
  }
}
