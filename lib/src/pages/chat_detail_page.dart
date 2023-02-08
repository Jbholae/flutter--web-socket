import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

import '../models/rooms/chat_room_model.dart';
import '../../config.dart';
import '../config/firebase/auth.dart';
import '../injector.dart';
import '../models/chat_message_model.dart';
import '../providers/auth_provider.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({
    super.key,
    required this.chatData,
  });

  final ChatRoom chatData;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final messageController = TextEditingController();
  late final IOWebSocketChannel channel;
  late BehaviorSubject<List<ChatMessage>> messageStream =
  BehaviorSubject<List<ChatMessage>>()
    ..addStream(apiService.getUserMessage(roomId: widget.chatData.id).asStream());

  @override
  void initState() {
    setState(() {
      (() async {
        channel = IOWebSocketChannel.connect(
          "${Config.socketUrl}/rooms/chat/${widget.chatData.id}",
          headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ${await firebaseAuth.currentUser?.getIdToken()}',
          },
        );
        channel.stream.listen((event) {
          final data = ChatMessage.fromJson(jsonDecode(event));
          messageStream.add(messageStream.value
              .map((e) => (e.id == null || e.id == data.id) ? data : e)
              .toList());
        });
      })();
    });

    super.initState();
  }

  @override
  void dispose() {
    messageStream.close();
    channel.innerWebSocket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthProvider>().dbUser?.id;
    var chatUser =
        widget.chatData.users!.firstWhere((element) => element.id != uid);
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
                  chatUser.name,
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: messageStream.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    var data = snapshot.data;
                    return data!.isEmpty
                        ? const Center(
                            child: Text('Start a conversation !!!'),
                          )
                        : ListView.builder(
                            reverse: true,
                            itemCount: data.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 14, top: 10, bottom: 10),
                                child: Align(
                                  // alignment: (messages[index].messageType == "receiver"
                                  alignment: (data[index].userId !=
                                          firebaseAuth.currentUser!.uid
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (data[index].userId !=
                                              firebaseAuth.currentUser!.uid
                                          ? Colors.grey.shade200
                                          : Colors.blue[200]),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      data[index].text!,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'message',
                      controller: messageController,
                      validator: FormBuilderValidators.required(
                        errorText: "Cannot be Empty !",
                      ),
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      final text = messageController.text.trim();
                      if (text != "") {
                        final data = ChatMessage(
                          text: text,
                          userId: uid,
                          roomId: widget.chatData.id,
                          status: "Sending..."
                        );
                        messageStream.add([
                          data,
                          ...messageStream.value,
                        ]);
                        channel.innerWebSocket!.add(jsonEncode(data.toJson()));
                        messageController.clear();
                      }
                    },
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
