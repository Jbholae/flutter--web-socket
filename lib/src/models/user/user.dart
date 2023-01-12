import '../index.dart';

class User extends Indexable {
  User({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.updatedAt,
    this.createdAt,
  }) : super(0);

  dynamic id;
  String? name;
  String? email;
  String? password;
  String? updatedAt;
  String? createdAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['first_name'],
        email: json['email'],
        password: json['password'],
        updatedAt: json['updated_at'],
        createdAt: json['created_at'],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": name,
        "email": email,
        "password": password,
        "updated_at": updatedAt,
        "created_at": createdAt,
      };
}
