import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app.dart';
import '../core/utils/snack_bar.dart';
import '../injector.dart';
import '../models/rooms/chat_room_model.dart';
import '../providers/auth_provider.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  TextEditingController roomNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                "Name $index",
              ),
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/5.jpg"),
                maxRadius: 20,
              ),
              onTap: () {
                mainNavigator.currentState
                    ?.pushNamed("/chat", arguments: index.toString());
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: TextField(
                          controller: roomNameController,
                          decoration: const InputDecoration(
                            label: Text('Room Name'),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.red),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel_sharp,
                              ),
                              label: const Text('Cancel'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                var user = Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .dbUser;
                                final response = await apiService.createRoom(
                                  request: ChatRoom(
                                    name: roomNameController.text,
                                    ownerId: user?.id,
                                  ),
                                );
                                showSuccess(message: response as String);
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Confirm'),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: const Icon(
          Icons.add_outlined,
          size: 35,
        ),
      ),
    );
  }
}
