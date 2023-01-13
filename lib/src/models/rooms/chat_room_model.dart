class ChatRoom {
  int id;
  String name;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ChatRoom({
    required this.id,
    required this.name,
    this.createdAt,
    this.deletedAt,
    this.updatedAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['deleted_at'] = deletedAt;
    data['updated_at'] = updatedAt;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
