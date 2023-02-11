import '../index.dart';

class BaseUser extends Indexable {
  BaseUser({
    required this.id,
    required this.fullName,
    required this.email,
  }) : super(id);

  dynamic id;
  String fullName;
  String email;

  factory BaseUser.fromJson(Map<String, dynamic> json) => BaseUser(
    id: json['id'],
    email: json['email'],
    fullName: json['full_name'],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "full_name": fullName,
  };
}
