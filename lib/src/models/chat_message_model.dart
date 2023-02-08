class ChatMessage {
  int? id;
  String? text;
  int? roomId;
  String? userId;
  String? status;
  ChatMessage({
    this.id,
    this.text,
    this.roomId,
    this.userId,
    this.status,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        id: json['id'],
        // messageContent: json['message_content'],
        // messageType: json['message_type'],
        text: json['text'],
        roomId: json['room_id'],
        status: json['status'],
        userId: json['user_id']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "room_id": roomId,
        "user_id": userId,
        "status": status,
      };
}
