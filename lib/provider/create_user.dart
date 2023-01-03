import 'package:flutter/cupertino.dart';
import 'package:web_socket_test/api/api_services.dart';
import 'package:web_socket_test/models/chat_user_model.dart';

class CreateUserProvider with ChangeNotifier {
  ChatUsers users = ChatUsers();
  bool loading = false;

  createUser(
    String name,
    String email,
  ) async {
    loading = true;
    users = await APIServices().createUser(name, email);
    loading = false;
    notifyListeners();
  }
}
