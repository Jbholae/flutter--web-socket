import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show HttpHeaders;
import 'dart:math' show max, min;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show
        AppBar,
        BoxConstraints,
        BuildContext,
        CircleAvatar,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        Divider,
        EdgeInsets,
        Expanded,
        FontWeight,
        Icon,
        IconButton,
        Icons,
        InputDecoration,
        ListView,
        NetworkImage,
        Row,
        Scaffold,
        SizedBox,
        State,
        StatefulWidget,
        StreamBuilder,
        Text,
        TextEditingController,
        TextField,
        TextStyle,
        Theme,
        Widget;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;
import 'package:web_socket_channel/io.dart' show IOWebSocketChannel;

import '../../config.dart';
import '../injector.dart';
import '../models/chat_message_model.dart';
import '../models/rooms/room.dart';
import '../providers/auth_provider.dart';
import '../widgets/atoms/message_list_item.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = "chat";

  const ChatPage({super.key, required this.room});

  final Room room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final message = TextEditingController();
  final scrollController = ScrollController();
  late final IOWebSocketChannel ws = IOWebSocketChannel.connect(
    "${Config.socketUrl}/rooms/chat/${widget.room.id}",
    headers: {
      HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.getString('token')}',
    },
  );

  late BehaviorSubject<List<ChatMessage>> messageStream =
      BehaviorSubject<List<ChatMessage>>()
        ..addStream(apiService.getRoomMessage(widget.room.id).asStream());

  @override
  void initState() {
    scrollController.addListener(() async {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        messageStream.add(
          messageStream.value +
              await apiService.getRoomMessage(
                  widget.room.id, messageStream.value.last.createdAt),
        );
      }
    });

    ws.stream.listen((event) {
      final data = ChatMessage.fromJson(jsonDecode(event));
      messageStream.add(messageStream.value
          .map((e) => (e.id == null || e.id == data.id) ? data : e)
          .toList());
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    messageStream.close();
    ws.innerWebSocket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthProvider>().dbUser?.id;
    var chatUser = widget.room.users.firstWhere((element) => element.id != uid);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage:
                  NetworkImage("https://randomuser.me/api/portraits/men/5.jpg"),
              maxRadius: 18,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatUser.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: StreamBuilder<List<ChatMessage>>(
        stream: messageStream,
        builder: (context, snapshot) {
          if (kDebugMode && snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final messages = snapshot.data ?? [];
          final lastIndex = messages.length - 1;
          return Column(
            children: <Widget>[
              Expanded(
                child: messages.isEmpty
                    ? const Center(child: Text("Start a conversation"))
                    : ListView.separated(
                        reverse: true,
                        padding: const EdgeInsets.only(
                            bottom: 8, left: 12, right: 12),
                        controller: scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final lastIndex = messages.length - 1;
                          return MessageListItem(
                            message: messages[index],
                            messageUp:
                                messages.elementAt(min(index + 1, lastIndex)),
                            messageDown: messages.elementAt(max(index - 1, 0)),
                            index: index,
                            lastIndex: lastIndex,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          final message = messages[index];
                          final messageUp =
                              messages.elementAt(min(index + 1, lastIndex));
                          if (messageUp.userId != message.userId) {
                            final date = DateTime.parse(message.createdAt);
                            final diff = DateTime.now().difference(date).inDays;
                            final time = DateFormat.jm().format(date);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Center(
                                child: Text(
                                  diff > 6
                                      ? DateFormat.MMMEd().format(date)
                                      : diff > 1
                                          ? '${DateFormat.E().format(date)} $time'
                                          : time,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            );
                          }
                          return const Divider(
                            height: 2,
                            thickness: 0,
                            color: Colors.transparent,
                          );
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.blue[400],
                      constraints:
                          const BoxConstraints(minHeight: 16, minWidth: 16),
                      splashRadius: 18,
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: message,
                        minLines: 1,
                        maxLines: 6,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Aa",
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, size: 20),
                      color: Colors.blue[400],
                      constraints:
                          const BoxConstraints(minHeight: 16, minWidth: 16),
                      splashRadius: 18,
                      onPressed: () {
                        final text = message.text.trim();
                        if (text != "") {
                          final data = ChatMessage(
                            text: message.text.trim(),
                            userId: context.read<AuthProvider>().dbUser?.id,
                            roomId: widget.room.id,
                            status: 'Sending',
                            createdAt: DateTime.now().toUtc().toIso8601String(),
                            updatedAt: DateTime.now().toUtc().toIso8601String(),
                          );
                          messageStream.add([
                            data,
                            ...messageStream.value,
                          ]);
                          ws.innerWebSocket!.add(jsonEncode(data.toJson()));
                          message.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
