import 'user/user.dart';

class ChatMessage {
  int? id;
  String text;
  String userId;
  int roomId;
  User? user;
  String createdAt;
  String updatedAt;
  String? deletedAt;
  String status;

  ChatMessage({
    this.id,
    required this.status,
    required this.text,
    required this.roomId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.deletedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      text: json['text'] as String,
      status: json['status'] ?? "Sent",
      userId: json['user_id'] as String,
      roomId: json['room_id'] as int,
      createdAt: json['created_at'] ,
      updatedAt: json['updated_at'] ,
      deletedAt: json['deleted_at'] as String?,
      user: json['user'] != null
          ? User.fromJson(json['user'])
          : User(id: 0, fullName: "", email: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "status": status,
      "user_id": userId,
      "room_id": roomId,
      "user": user?.toJson() ?? {},
      "created_at": createdAt,
      "updated_at": updatedAt,
      "deleted_at": deletedAt,
    };
  }
}
