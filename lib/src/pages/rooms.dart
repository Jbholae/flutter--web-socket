import 'package:flutter/material.dart';

import '../app.dart';
import '../core/utils/snack_bar.dart';
import '../injector.dart';
import '../models/rooms/chat_room_model.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  Future<List<ChatRoom>> myFuture = apiService.getUserRoom();

  TextEditingController roomNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<ChatRoom>>(
            future: myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  return data!.isEmpty
                      ? const Center(
                          child: Text('No Rooms Found !!!'),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var chatData = data[index];
                            return ListTile(
                              title: Text(
                                "Name : ${chatData.name}",
                              ),
                              leading: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://randomuser.me/api/portraits/men/5.jpg"),
                                maxRadius: 20,
                              ),
                              onTap: () {
                                mainNavigator.currentState?.pushNamed(
                                  "/chat",
                                  arguments: index.toString(),
                                );
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
              }
              return const CircularProgressIndicator();
            }),
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
                                final response = await apiService.createRoom(
                                  request: ChatRoom(
                                    name: roomNameController.text,
                                  ),
                                );
                                Navigator.pop(context);
                                showSuccess(message: response.data['msg']);
                                setState(() {
                                  myFuture = apiService.getUserRoom();
                                });
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
