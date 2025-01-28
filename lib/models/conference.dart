class Conference {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String startDate;
  final String endDate;
  final bool isActive;
  final int createdBy;
  final Map<String, dynamic> daysDuration;

  Conference({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdBy,
    required this.daysDuration,
  });

  factory Conference.fromJson(Map<String, dynamic> json) {
    return Conference(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      isActive: json['is_active'],
      createdBy: json['created_by'],
      daysDuration: json['days_duration'],
    );
  }
}