import 'base_user.dart';

class User extends BaseUser {
  User({
    super.id,
    required super.email,
    required super.fullName,
    this.password,
    this.updatedAt,
    this.createdAt,
  }) : super();

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
        ...super.toJson(),
        "password": password,
        "updated_at": updatedAt,
        "created_at": createdAt,
      };
}
