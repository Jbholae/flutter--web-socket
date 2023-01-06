import '../models/rooms/chat_room_model.dart';
import '../models/user/user.dart';

abstract class AppRepo {
  Future createUser({required User data});

  Future createRoom({ChatRoom? request});

  Future getUserRoom(int userId);
}
