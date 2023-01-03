import 'package:flutter/cupertino.dart';
import 'package:web_socket_test/api/api_services.dart';
import 'package:web_socket_test/models/chat_room_model.dart';

class UserChatRoomsProvider with ChangeNotifier {
  ChatRoom chatRoom = ChatRoom();
  bool loading = false;

  getChatRoom(int userId) async {
    loading = true;
    chatRoom = await APIServices().getUserRoom(userId);
    loading = false;
    notifyListeners();
  }
}
