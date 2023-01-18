import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_test/src/models/rooms/chat_room_model.dart';

import '../../config.dart';
import '../config/firebase/auth.dart';
import '../injector.dart';
import '../models/chat_message_model.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({
    super.key,
    this.chatData,
  });

  final ChatRoom? chatData;

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final formKey = GlobalKey<FormBuilderState>();
  final messageController = TextEditingController();
  int? id = 0;
  var token = sharedPreferences.getString('token');

  // final int id = 0;
  // List<ChatMessage> messages = [
  //   ChatMessage(
  //     messageContent: "Hello, Will",
  //     messageType: "receiver",
  //   ),
  //   ChatMessage(
  //     messageContent: "How have you been?",
  //     messageType: "receiver",
  //   ),
  //   ChatMessage(
  //     messageContent: "Hey Kriss, I am doing fine dude. wbu?",
  //     messageType: "sender",
  //   ),
  //   ChatMessage(
  //     messageContent: "ehhhh, doing OK.",
  //     messageType: "receiver",
  //   ),
  //   ChatMessage(
  //     messageContent: "Is there any thing wrong?",
  //     messageType: "sender",
  //   ),
  // ];

  IOWebSocketChannel? channel;

  // @override
  // void initState() {
  //   setState(() {
  //     (() async {
  //       channel = IOWebSocketChannel.connect(
  //         "${Config.socketUrl}/rooms/chat/${widget.chatData?.id}",
  //         headers: {
  //           HttpHeaders.authorizationHeader:
  //               'Bearer ${await firebaseAuth.currentUser?.getIdToken()}',
  //         },
  //       );
  //       channel.stream.listen((event) {
  //         print(event);
  //       }, onError: (error) {
  //         print("Error : $error");
  //       });
  //     })();
  //   });

  //   super.initState();
  // }
  @override
  void initState() {
    id = widget.chatData!.id;
    channel = IOWebSocketChannel.connect(
      "${Config.socketUrl}/rooms/chat/$id",
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    channel!.innerWebSocket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/5.jpg"),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${widget.chatData?.name}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: channel!.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          // ListView.builder(
          //   itemCount: messages.length,
          //   shrinkWrap: true,
          //   padding: const EdgeInsets.only(top: 10, bottom: 10),
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemBuilder: (context, index) {
          //     return Container(
          //       padding: const EdgeInsets.only(
          //           left: 14, right: 14, top: 10, bottom: 10),
          //       child: Align(
          //         alignment: (messages[index].messageType == "receiver"
          //             ? Alignment.topLeft
          //             : Alignment.topRight),
          //         child: Container(
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(20),
          //             color: (messages[index].messageType == "receiver"
          //                 ? Colors.grey.shade200
          //                 : Colors.blue[200]),
          //           ),
          //           padding: const EdgeInsets.all(16),
          //           child: Text(
          //             messages[index].messageContent!,
          //             style: const TextStyle(fontSize: 15),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // ),
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
                    child: FormBuilder(
                      key: formKey,
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
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      channel!.innerWebSocket?.add(messageController.text
                          // formKey.currentState?.value['message'],
                          );
                      messageController.clear();
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
