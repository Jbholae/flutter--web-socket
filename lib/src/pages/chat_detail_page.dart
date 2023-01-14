import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show HttpHeaders;

import 'package:flutter/material.dart'
    show
        AppBar,
        BorderRadius,
        BoxConstraints,
        BoxDecoration,
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
        TextDirection,
        TextEditingController,
        TextField,
        TextStyle,
        Theme,
        Widget;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart' show Consumer;
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart' show IOWebSocketChannel;

import '../../config.dart';
import '../config/firebase/auth.dart';
import '../injector.dart';
import '../models/chat_message_model.dart';
import '../models/rooms/chat_room_model.dart';
import '../providers/auth_provider.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, required this.room});

  final ChatRoom room;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late final IOWebSocketChannel ws;
  late final TextEditingController message = TextEditingController();

  late BehaviorSubject<List<ChatMessage>> messageStream =
      BehaviorSubject<List<ChatMessage>>()
        ..addStream(apiService.getRoomMessages(widget.room.id).asStream());

  @override
  void initState() {
    String baseUrl =
        Config.apiUrl.replaceRange(0, Config.apiUrl.indexOf("/") + 2, "");
    firebaseAuth.currentUser?.getIdToken().then((value) {
      setState(() {
        ws = IOWebSocketChannel.connect(
          'ws://$baseUrl/rooms/chat/${widget.room.id}',
          headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
        );

        ws.stream.listen((event) {
          messageStream.add([
            ChatMessage.fromJson(jsonDecode(event)),
            ...messageStream.value,
          ]);
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    messageStream.close();
    ws.innerWebSocket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.room.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Online",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            )
          ],
        ),
      ),
      body: StreamBuilder<List<ChatMessage>>(
          stream: messageStream,
          builder: (context, snapshot) {
            final messages = snapshot.data ?? [];
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    reverse: true,
                    itemCount: messages.length,
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 12, right: 12),
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Consumer<AuthProvider>(
                          builder: (context, value, _) {
                        final isUser = value.user!.uid == message.userId;
                        return Row(
                          textDirection:
                              isUser ? TextDirection.rtl : TextDirection.ltr,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isUser) ...[
                              const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://randomuser.me/api/portraits/men/7.jpg"),
                                maxRadius: 12,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: !isUser
                                    ? Colors.grey[800]
                                    : Colors.blue[400],
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                message.text.trim(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            )
                          ],
                        );
                      });
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 2,
                        thickness: 0,
                        color: Colors.transparent,
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                      // const SizedBox(width: ),
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
                            ws.innerWebSocket!.add(jsonEncode({
                              "text": message.text.trim(),
                            }));
                            message.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
