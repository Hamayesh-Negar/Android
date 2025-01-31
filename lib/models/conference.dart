class Conference {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final Map<String, dynamic> daysDuration;

  Conference({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.daysDuration,
  });

  factory Conference.fromJson(Map<String, dynamic> json) {
    return Conference(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isActive: json['is_active'],
      daysDuration: json['days_duration'],
    );
  }
}
