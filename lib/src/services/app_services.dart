import 'package:dio/dio.dart';

import '../config/api/api.dart';
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
      "/rooms",
      data: request!.toJson(),
    );
  }

  @override
  Future<List<ChatRoom>> getUserRoom(String? userId) async {
    final response = await dio.get("/rooms/$userId");
    List data = response.data['data'];
    List<ChatRoom> dataList = data.map((e) => ChatRoom.fromJson(e)).toList();
    return dataList;
  }
}
