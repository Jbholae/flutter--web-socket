import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../app.dart';
import '../injector.dart';
import '../models/rooms/chat_room_model.dart';
import '../providers/auth_provider.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  Future<List<ChatRoom>> myFuture = apiService.getUserRoom();

  @override
  Widget build(BuildContext context) {
    final uid = context
        .read<AuthProvider>()
        .dbUser
        ?.id;
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
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var chatData = data[index];
                      var chatUser = chatData.users!
                          .firstWhere((element) => element.id != uid);
                      return ListTile(
                        title: Text(
                          chatUser.name,
                        ),
                        subtitle: Text(
                            "${"<Latest Message here>"} . ${DateFormat.jm().format(DateTime.now())}"
                        ),
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://randomuser.me/api/portraits/men/5.jpg"),
                          maxRadius: 24,
                        ),
                        onTap: () {
                          mainNavigator.currentState?.pushNamed(
                            "/chat",
                            arguments: chatData,
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
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
