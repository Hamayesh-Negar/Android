class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String userType;
  final bool isActive;
  final String dateJoined;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.userType,
    required this.isActive,
    required this.dateJoined,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      userType: json['user_type'],
      isActive: json['is_active'],
      dateJoined: json['date_joined'],
    );
  }
}