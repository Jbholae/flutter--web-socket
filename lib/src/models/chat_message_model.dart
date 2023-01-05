
class ChatMessage {
  String? id;
  String? text;
  String? userRoomId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String? messageContent;
  String? messageType;
  ChatMessage({
    this.messageContent,
    this.messageType,
    this.createdAt,
    this.deletedAt,
    this.id,
    this.text,
    this.updatedAt,
    this.userRoomId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      id: json['id'],
      messageContent: json['message_content'],
      messageType: json['message_type'],
      text: json['text'],
      updatedAt: json['updated_at'],
      userRoomId: json['user_room_id'],
    );
  }
}
