import 'package:dio/dio.dart';

import '../config/api/api.dart';
import '../models/rooms/chat_room_model.dart';
import '../models/user/user.dart';
import 'app_repo.dart';

class AppRepoImplementation implements AppRepo {
  @override
  Future<Response> createUser({required User data}) {
    return dio.post(
      "/users",
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
  Future getUserRoom(int? userId) async {
    return await dio.get("/rooms/$userId");
  }
}
