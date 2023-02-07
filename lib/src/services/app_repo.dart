import '../models/chat_message_model.dart';
import '../models/rooms/chat_room_model.dart';
import '../models/user/user.dart';

abstract class AppRepo {
  Future createUser({required User data});

  Future getAllUser({String keyword, String cursor});

  Future createRoom({ChatRoom? request});

  Future getUserRoom({String? cursor});

  // Future createUserMessage({int? roomId, ChatMessage? chatMessage});

  Stream getUserMessage({int roomId});

  Future followUser({String userId});

  Future unFollowUser({String userID});
}
