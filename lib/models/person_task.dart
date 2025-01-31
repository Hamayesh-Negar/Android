class PersonTask {
  final int id;
  final int person;
  final int task;
  final String status;
  final String? notes;
  final DateTime? completedAt;
  final int? completedBy;
  final String personName;
  final String taskName;

  PersonTask({
    required this.id,
    required this.person,
    required this.task,
    required this.status,
    this.notes,
    this.completedAt,
    this.completedBy,
    required this.personName,
    required this.taskName,
  });

  factory PersonTask.fromJson(Map<String, dynamic> json) {
    return PersonTask(
      id: json['id'],
      person: json['person'],
      task: json['task'],
      status: json['status'],
      notes: json['notes'],
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      completedBy: json['completed_by'],
      personName: json['person_name'],
      taskName: json['task_name'],
    );
  }
}
