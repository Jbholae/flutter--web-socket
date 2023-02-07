import 'package:flutter/material.dart';

import '../injector.dart';
import '../models/rooms/chat_room_model.dart';
import 'chat_detail_page.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  Future<List<ChatRoom>> myFuture = apiService.getUserRoom();

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
                          child: Text('No Rooms Not Found !!!'),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatDetailPage(
                                      chatData: chatData,
                                    ),
                                  ),
                                );
                                // mainNavigator.currentState?.pushNamed(
                                //   "/chat",
                                //   arguments: chatData,
                                // );
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
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
