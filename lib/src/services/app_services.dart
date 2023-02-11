import 'package:dio/dio.dart';

import '../config/api/api.dart';
import '../dtos/user/user_list.dart';
import '../models/chat_message_model.dart';
import '../models/rooms/room.dart';
import '../models/user/user.dart';
import 'app_repo.dart';

class AppRepoImplementation implements AppRepo {
  @override
  Future<Response> createUser({required User data}) {
    return dio.post("/create", data: data.toJson());
  }

  @override
  Future<List<Room>> getUserRoom({String? cursor}) async {
    final response = await dio.get("/rooms/get-rooms", queryParameters: {
      "cursor": cursor ?? DateTime.now().toUtc().toIso8601String(),
    });
    List data = response.data['data'] ?? [];
    List<Room> dataList = data.map((e) => Room.fromJson(e)).toList();
    return dataList;
  }

  @override
  Future<List<ChatMessage>> getRoomMessage(int roomId, [String? cursor]) async {
    final response = await dio.get(
      "/rooms/messages/$roomId",
      queryParameters: {
        "cursor": cursor ?? DateTime.now().toUtc().toIso8601String(),
      },
    );
    List data = response.data['data'] ?? [];
    return data.map((e) => ChatMessage.fromJson(e)).toList();
  }

  @override
  Future<List<UserList>> getAllUser({String? keyword, String? cursor}) async {
    final response = await dio.get('/users/get-all', queryParameters: {
      "keyword": keyword,
      "cursor": cursor ?? DateTime.now().toUtc().toIso8601String(),
    });
    List data = response.data['data'] ?? [];
    return data.map((e) => UserList.fromJson(e)).toList();
  }

  @override
  Future followUser({String? userId}) async {
    return await dio.patch("/followers/add/$userId");
  }

  @override
  Future unFollowUser({String? userID}) async {
    return await dio.delete('/followers/delete/$userID');
  }
}
