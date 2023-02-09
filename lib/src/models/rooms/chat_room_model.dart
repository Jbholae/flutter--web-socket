import '../user/user.dart';

class ChatRoom {
  int id;
  String? name;
  bool? isPrivate;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Iterable<User>? users;

  ChatRoom({
    required this.id,
    this.name,
    this.isPrivate,
    this.users,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      id: json['id'],
      name: json['name'],
      updatedAt: json['updated_at'],
      isPrivate: json['is_private'],
      users: (json["users"] as List).map((e) => User.fromJson(e)),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'created_at': createdAt,
      'deleted_at': deletedAt,
      'updated_at': updatedAt,
      'id': id,
      'name': name,
      'is_private': isPrivate,
      'users': users?.map((e) => e.toJson()),
    };
  }
}
