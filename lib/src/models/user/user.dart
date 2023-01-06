import '../index.dart';

class User extends Indexable {
  User({
    required this.id,
    required this.name,
    required this.email,
    this.updatedAt,
    this.createdAt,
  }) : super(id);

  int id;
  String? name;
  String? email;
  String? updatedAt;
  String? createdAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        name: json['first_name'],
        email: json['email'],
        updatedAt: json['updated_at'],
        createdAt: json['created_at'],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": name,
        "email": email,
        "updated_at": updatedAt,
        "created_at": createdAt,
      };
}
