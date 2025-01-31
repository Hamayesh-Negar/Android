class Task {
  final int id;
  final int conference;
  final String name;
  final String? description;
  final bool isRequired;
  final bool isActive;
  final DateTime? dueDate;
  final int assignmentCount;
  final double completionRate;

  Task({
    required this.id,
    required this.conference,
    required this.name,
    this.description,
    required this.isRequired,
    required this.isActive,
    this.dueDate,
    required this.assignmentCount,
    required this.completionRate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      conference: json['conference'],
      name: json['name'],
      description: json['description'],
      isRequired: json['is_required'],
      isActive: json['is_active'],
      dueDate:
          json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      assignmentCount: json['assignment_count'],
      completionRate: json['completion_rate'].toDouble(),
    );
  }
}
