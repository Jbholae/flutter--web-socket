class ChatRoom {
  int? id;
  String? name;
  int? ownerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  ChatRoom({
    this.createdAt,
    this.deletedAt,
    this.id,
    this.ownerId,
    this.name,
    this.updatedAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      id: json['id'],
      name: json['name'],
      ownerId: json['owner_id'],
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
    data['owner_id'] = ownerId;
    return data;
  }
}
