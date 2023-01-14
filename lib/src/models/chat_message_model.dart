import 'user/user.dart';

class ChatMessage {
  int id;
  String text;
  String userId;
  int roomId;
  User user;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.roomId,
    required this.userId,
    required this.user,
    this.deletedAt,
    this.updatedAt,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int,
      text: json['text'] as String,
      userId: json['user_id'] as String,
      roomId: json['room_id'] as int,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      user: User.fromJson(json['user']),
    );
  }
}
