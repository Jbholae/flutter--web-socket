import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:web_socket_test/provider/create_room.dart';
import 'package:web_socket_test/provider/create_user.dart';
import 'package:web_socket_test/provider/user_chat_rooms.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<CreateUserProvider>(
    create: (context) => CreateUserProvider(),
  ),
  ChangeNotifierProvider<UserChatRoomsProvider>(
    create: (context) => UserChatRoomsProvider(),
  ),
  ChangeNotifierProvider<CreateRoomProvider>(
    create: (context) => CreateRoomProvider(),
  ),
];
