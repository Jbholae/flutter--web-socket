import '../models/chat_message_model.dart';
import '../models/user/user.dart';

abstract class AppRepo {
  Future createUser({required User data});

  Future getAllUser({String keyword, String cursor});

  Future getUserRoom({String? cursor});

  Future<List<ChatMessage>> getRoomMessage(int roomId, [String? cursor]);

  Future followUser({String userId});

  Future unFollowUser({String userID});
}
