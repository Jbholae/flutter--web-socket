class ChatMessage {
  int? id;
  String? text;
  int? userRoomId;
  String? userId;
  ChatMessage({
    this.id,
    this.text,
    this.userRoomId,
    this.userId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        id: json['id'],
        // messageContent: json['message_content'],
        // messageType: json['message_type'],
        text: json['text'],
        userRoomId: json['room_id'],
        userId: json['user_id']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "room_id": userRoomId,
        "user_id": userId,
      };
}
