class TimelineEntry {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime timestamp;

  TimelineEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.timestamp,
  });

  factory TimelineEntry.fromJson(Map<String, dynamic> json) {
    return TimelineEntry(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Event',
      description: json['description'] ?? '',
      category: json['category'] ?? 'activity',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
