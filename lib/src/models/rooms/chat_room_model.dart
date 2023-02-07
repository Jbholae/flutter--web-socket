import '../user/user.dart';

class ChatRoom {
  int? id;
  String? name;
  bool? isPrivate;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Iterable<User>? users;

  ChatRoom({
    this.createdAt,
    this.deletedAt,
    this.id,
    this.name,
    this.updatedAt,
    this.isPrivate,
    this.users,
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
