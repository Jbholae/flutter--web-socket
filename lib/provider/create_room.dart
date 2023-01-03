import 'package:flutter/cupertino.dart';
import 'package:web_socket_test/api/api_services.dart';
import 'package:web_socket_test/models/chat_room_model.dart';

class CreateRoomProvider extends ChangeNotifier {
  ChatRoom chatRoom = ChatRoom();
  bool loading = false;

  createRoom(String name) async {
    loading = true;
    chatRoom = await APIServices().createRoom(name);
    loading = false;
    notifyListeners();
  }
}
