import '../chat_message_model.dart';
import '../user/user.dart';

class ChatRoom {
  int id;
  String? name;
  bool isPrivate;
  String createdAt;
  String updatedAt;
  String? deletedAt;
  Iterable<User> users;
  ChatMessage? latestMessage;

  ChatRoom({
    required this.id,
    required this.isPrivate,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
    this.name,
    this.latestMessage,
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
      latestMessage: json['latest_message'] != null
          ? ChatMessage.fromJson(json['latest_message'])
          : null,
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
      'latest_message': latestMessage?.toJson(),
      'users': users.map((e) => e.toJson()),
    };
  }
}
