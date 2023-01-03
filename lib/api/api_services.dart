import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:web_socket_test/models/chat_room_model.dart';
import 'package:web_socket_test/models/chat_user_model.dart';

class APIServices {
  var dio = Dio();
  var dioError = DioError;
  var response = Response;

  Future<ChatUsers> createUser(String name, String email) async {
    ChatUsers chatUsers = ChatUsers();
    try {
      var formData = FormData.fromMap({
        "name": name,
        "email": email,
      });
      final response = await dio.post(
        "localhost:8000/users",
        data: FormData.fromMap({
          "name": name,
          "email": email,
        }),
      );
      if (response.statusCode == 200) {
        var data = ChatUsers.fromJson(response.data);
        chatUsers = data;
        return chatUsers;
      }
    } catch (e) {
      log(e.toString());
    }

    return chatUsers;
  }

  Future<ChatRoom> createRoom(String name) async {
    ChatRoom chatRoom = ChatRoom();
    try {
      final response = await dio.post("localhost:8000/rooms",
          data: FormData.fromMap({
            "name": name,
          }));
      if (response.statusCode == 200) {
        var data = ChatRoom.fromJson(response.data);
        chatRoom = data;
        return chatRoom;
      }
    } catch (e) {
      log(e.toString());
    }
    return chatRoom;
  }

  Future<ChatRoom> getUserRoom(int userId) async {
    ChatRoom chatRoom = ChatRoom();
    try {
      final response = await dio.get("localhost:8000/user/$userId");
      if (response.statusCode == 200) {
        var data = ChatRoom.fromJson(response.data);
        chatRoom = data;
        return chatRoom;
      }
    } catch (e) {
      log(e.toString());
    }
    return chatRoom;
  }
}
