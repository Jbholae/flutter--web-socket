import 'package:dio/dio.dart';

import '../config/api/api.dart';
import '../models/chat_message_model.dart';
import '../models/rooms/chat_room_model.dart';
import '../models/user/get_all_user_response.dart/get_all_user_response.dart';
import '../models/user/user.dart';
import 'app_repo.dart';

class AppRepoImplementation implements AppRepo {
  var cursor = DateTime.now().toUtc().toIso8601String();

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
    var cursor = DateTime.now().toUtc().toIso8601String();
    cursor == "" ? DateTime.now().toUtc().toIso8601String() : cursor;

    final response = await dio.get("/rooms/get-rooms", queryParameters: {
      "cursor": cursor,
    });
    List data = response.data['data'];
    List<ChatRoom> dataList = data.map((e) => ChatRoom.fromJson(e)).toList();
    return dataList;
  }

  @override
  Stream<List<ChatMessage>> getUserMessage({int? roomId}) async* {
    var cursor = DateTime.now().toUtc().toIso8601String();

    cursor == "" ? DateTime.now().toUtc().toIso8601String() : cursor;

    final response = await dio.get("/rooms/messages/$roomId", queryParameters: {
      "cursor": cursor,
    });
    List data = response.data['data'];
    List<ChatMessage> messageList =
        data.map((e) => ChatMessage.fromJson(e)).toList();
    yield messageList;
  }

  // @override
  // Future createUserMessage({int? roomId, ChatMessage? chatMessage}) async {
  //   final response = await dio.post("/rooms/create-message/$roomId",
  //       data: chatMessage?.toJson());
  //   return response;
  // }

  @override
  Future<List<GetAllUserResponseData>> getAllUser(
      {String? keyword, String? cursor}) async {
    String cursor = DateTime.now().toUtc().toIso8601String();
    cursor == "" ? DateTime.now().toUtc().toIso8601String() : cursor;
    final response = await dio.get('/users/get-all?$cursor?keyword=$keyword');
    List data = response.data['data'];
    List<GetAllUserResponseData> userList =
        data.map((e) => GetAllUserResponseData.fromJson(e)).toList();
    return userList;
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
