import 'package:flutter/material.dart';

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
    @required this.name,
    @required this.messageText,
    @required this.imageURL,
    @required this.time,
  });
  factory ChatUsers.fromJson(Map<String, dynamic> json) {
    return ChatUsers(
      name: json['name'],
      messageText: json['message_text'],
      imageURL: json['image_url'],
      time: json['time'],
    );
  }
}
