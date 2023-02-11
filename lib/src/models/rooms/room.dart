import '../chat_message_model.dart';
import '../user/user.dart';
import 'base_room.dart';

class Room extends BaseRoom {
  Iterable<User> users;
  ChatMessage? latestMessage;

  Room({
    super.name,
    super.deletedAt,
    required super.id,
    required super.isPrivate,
    required super.createdAt,
    required super.updatedAt,
    this.latestMessage,
    required this.users,
  }) : super();

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
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

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ...super.toJson(),
      'latest_message': latestMessage?.toJson(),
      'users': users.map((e) => e.toJson()),
    };
  }
}
