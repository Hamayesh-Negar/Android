class Person {
  final int id;
  final int conference;
  final List<int> categories;
  final String firstName;
  final String lastName;
  final String? telephone;
  final String? email;
  final String uniqueCode;
  final String hashedUniqueCode;
  final bool isActive;
  final int taskCount;
  final int completedTaskCount;

  Person({
    required this.id,
    required this.conference,
    required this.categories,
    required this.firstName,
    required this.lastName,
    this.telephone,
    this.email,
    required this.uniqueCode,
    required this.hashedUniqueCode,
    required this.isActive,
    required this.taskCount,
    required this.completedTaskCount,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      conference: json['conference'],
      categories: List<int>.from(json['categories']),
      firstName: json['first_name'],
      lastName: json['last_name'],
      telephone: json['telephone'],
      email: json['email'],
      uniqueCode: json['unique_code'],
      hashedUniqueCode: json['hashed_unique_code'],
      isActive: json['is_active'],
      taskCount: json['task_count'],
      completedTaskCount: json['completed_task_count'],
    );
  }
}
