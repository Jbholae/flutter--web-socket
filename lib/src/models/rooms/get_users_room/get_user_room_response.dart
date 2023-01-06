class ChatRoomResponse {
  List<ChatRoomResponseData>? responseData;
  ChatRoomResponse({this.responseData});

  ChatRoomResponse.fromJson(Map<String, dynamic> json) {
    responseData = json['data']
        .map<ChatRoomResponse>((e) => ChatRoomResponse.fromJson(e))
        .toList();
  }
}

class ChatRoomResponseData {
  String? id;
  String? name;
  int? ownerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  ChatRoomResponseData({
    this.createdAt,
    this.deletedAt,
    this.id,
    this.ownerId,
    this.name,
    this.updatedAt,
  });

  factory ChatRoomResponseData.fromJson(Map<String, dynamic> json) {
    return ChatRoomResponseData(
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
