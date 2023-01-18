import 'dart:io';

import 'package:dio/dio.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_test/src/config/firebase/auth.dart';

import '../../config.dart';
import '../config/api/api.dart';
import '../models/chat_message_model.dart';
import '../models/rooms/chat_room_model.dart';
import '../models/user/user.dart';
import 'app_repo.dart';

class AppRepoImplementation implements AppRepo {
  @override
  Future<Response> createUser({required User data}) {
    return dio.post(
      "/create",
      data: data.toJson(),
    );
  }

  @override
  Future createRoom({ChatRoom? request}) async {
    return await dio.post(
      "/rooms/create",
      data: request!.toJson(),
    );
  }

  @override
  Future<List<ChatRoom>> getUserRoom({String? cursor}) async {
    cursor == "" ? DateTime.now().toIso8601String() : cursor;
    final response = await dio.get("/rooms/get-rooms/$cursor");
    List data = response.data['data'];
    List<ChatRoom> dataList = data.map((e) => ChatRoom.fromJson(e)).toList();
    return dataList;
  }

  @override
  Future<List<ChatMessage>> getUserMessage(
      {int? roomId, String? cursor}) async {
    cursor == "" ? DateTime.now().toIso8601String() : cursor;

    final response = await dio.get("/rooms/messages/$roomId/$cursor");
    List data = response.data['data'];
    List<ChatMessage> messageList =
        data.map((e) => ChatMessage.fromJson(e)).toList();
    return messageList;
  }
}
