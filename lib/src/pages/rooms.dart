import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../app.dart';
import '../injector.dart';
import '../models/chat_message_model.dart';
import '../models/rooms/chat_room_model.dart';
import '../providers/auth_provider.dart';
import '../providers/message_notifier_provider.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  BehaviorSubject<List<ChatRoom>> roomStream = BehaviorSubject<List<ChatRoom>>()
    ..addStream(apiService.getUserRoom().asStream());

  @override
  void initState() {
    context.read<MessageNotifierProvider>().notifyStream.listen((event) {
      final data = ChatMessage.fromJson(jsonDecode(event));
      roomStream.add(roomStream.value.map((e) {
        e.latestMessage = (e.id == data.roomId) ? data : null;
        return e;
      }).toList());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthProvider>().dbUser?.id;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<ChatRoom>>(
          stream: roomStream.stream,
          builder: (context, snapshot) {
            if (kDebugMode && snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            var data = snapshot.data ?? [];
            return data.isEmpty
                ? const Center(
                    child: Text('Start making friends to chat'),
                  )
                : ListView.separated(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var room = data[index];
                      var chatUser =
                          room.users.firstWhere((element) => element.id != uid);
                      return ListTile(
                        title: Text(
                          chatUser.fullName,
                          style: room.latestMessage != null
                              ? Theme.of(context).textTheme.subtitle1
                              : Theme.of(context).textTheme.subtitle2,
                        ),
                        subtitle: Text(
                          room.latestMessage != null
                              ? "${room.latestMessage!.text} . ${DateFormat.jm().format(DateTime.parse(room.latestMessage!.createdAt).toLocal())}"
                              : "Click to start chatting",
                          style: room.latestMessage != null
                              ? Theme.of(context).textTheme.bodyText1
                              : Theme.of(context).textTheme.bodyText2,
                        ),
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://randomuser.me/api/portraits/men/5.jpg",
                          ),
                          maxRadius: 24,
                        ),
                        trailing: room.latestMessage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: Colors.blue[400],
                                ),
                              )
                            : const SizedBox(),
                        onTap: () {
                          mainNavigator.currentState?.pushNamed(
                            "/chat",
                            arguments: room,
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const Divider();
                    },
                  );
          },
        ),
      ),
    );
  }
}
