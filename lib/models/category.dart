class Category {
  final int id;
  final int conference;
  final String name;
  final String? description;
  final int membersCount;

  Category({
    required this.id,
    required this.conference,
    required this.name,
    this.description,
    required this.membersCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      conference: json['conference'],
      name: json['name'],
      description: json['description'],
      membersCount: json['members_count'],
    );
  }
}
