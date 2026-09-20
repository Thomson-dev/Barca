class Profile {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
