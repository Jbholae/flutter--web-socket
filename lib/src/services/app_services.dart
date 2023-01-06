import '../config/api/api.dart';
import '../models/rooms/chat_room_model.dart';
import '../models/user/create_user/create_user_request.dart';
import 'app_repo.dart';

class AppRepoImplementation implements AppRepo {
  @override
  Future createUser({CreateUserRequest? request}) async {
    return await dio.post(
      "/users",
      data: request!.toJson(),
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
