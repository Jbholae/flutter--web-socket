
import '../core/utils/api_error.dart';
import '../models/rooms/chat_room_model.dart';
import '../models/rooms/create_room_response.dart';
import '../models/user/create_user/create_user_request.dart';
import '../models/user/create_user/create_user_response.dart';
import '../network/api_handler.dart';
import 'app_repo.dart';

class AppRepoImplementation implements AppRepo {
  @override
  Future createUser({CreateUserRequest? request}) async {
    final response = await APIHandler.post(
      url: "localhost:8000/users",
      requestBody: request!.toJson(),
    );

    if (response is APIError) {
      return response;
    } else {
      return CreateUserResponse.fromJson(response);
    }
  }

  @override
  Future createRoom({ChatRoom? request}) async {
    final response = await APIHandler.post(
      url: "localhost:8000/rooms",
      requestBody: request!.toJson(),
    );

    if (response is APIError) {
      return response;
    } else {
      return ChatRoomResponse.fromJson(response);
    }
  }

  @override
  Future getUserRoom(int? userId) async {
    final response = await APIHandler.get(url: "localhost:8000/rooms/$userId");

    if (response is APIError) {
      return response.status;
    } else {
      return ChatRoomResponse.fromJson(response);
    }
  }
}
