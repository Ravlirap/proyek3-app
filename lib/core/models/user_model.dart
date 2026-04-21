class UserModel {
  final int id;
  final String name;
  final String email;
  final String? source;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.source,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      source: json['source'] as String?,
    );
  }
}
