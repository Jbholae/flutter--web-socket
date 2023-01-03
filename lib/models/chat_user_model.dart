class ChatUsers {
  String? id;
  String? name;
  String? email;
  String? messageText;
  String? imageURL;
  String? time;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  ChatUsers({
    this.name,
    this.messageText,
    this.email,
    this.imageURL,
    this.time,
  });
  factory ChatUsers.fromJson(Map<String, dynamic> json) {
    return ChatUsers(
      name: json['name'],
      email: json['email'],
      messageText: json['message_text'],
      imageURL: json['image_url'],
      time: json['time'],
    );
  }
}
