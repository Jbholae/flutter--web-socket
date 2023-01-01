class ChatRoom {
  String? id;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  ChatRoom({
    this.createdAt,
    this.deletedAt,
    this.id,
    this.title,
    this.updatedAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      id: json['id'],
      title: json['title'],
      updatedAt: json['updated_at'],
    );
  }
}
