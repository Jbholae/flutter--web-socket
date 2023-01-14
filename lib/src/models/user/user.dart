import '../index.dart';

class User extends Indexable {
  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.password,
    this.updatedAt,
    this.createdAt,
  }) : super(0);

  dynamic id;
  String fullName;
  String email;
  String? password;
  String? updatedAt;
  String? createdAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        fullName: json['full_name'],
        password: json['password'] as String?,
        updatedAt: json['updated_at'] as String?,
        createdAt: json['created_at'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "full_name": fullName,
        "password": password,
        "updated_at": updatedAt,
        "created_at": createdAt,
      };
}
