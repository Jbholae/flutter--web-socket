import '../../models/user/base_user.dart';

class UserList extends BaseUser {
  bool followStatus;

  UserList({
    super.id,
    required super.email,
    required super.fullName,
    required this.followStatus,
  });

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
        email: json['email'],
        fullName: json['full_name'],
        id: json['id'],
        followStatus: json['follow_status'],
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'follow_status': followStatus,
      };
}
