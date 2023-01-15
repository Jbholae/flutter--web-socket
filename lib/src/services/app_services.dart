import 'package:dio/dio.dart';

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
  Future<List<ChatRoom>> getUserRoom() async {
    final response = await dio.get("/rooms/get-rooms");
    List data = response.data['data'];
    List<ChatRoom> dataList = data.map((e) => ChatRoom.fromJson(e)).toList();
    return dataList;
  }

  @override
  Future<List<ChatMessage>> getRoomMessages(int roomId, [String? cursor]) async {
    final response = await dio.get(
      "/rooms/messages/$roomId",
      queryParameters: {
        "cursor": cursor ?? DateTime.now().toUtc().toIso8601String(),
      },
    );
    List data = response.data['data'];
    return data.map((e) => ChatMessage.fromJson(e)).toList();
  }
}
