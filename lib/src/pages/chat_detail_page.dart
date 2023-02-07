import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_test/src/config/api/api.dart';
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

  IOWebSocketChannel? channel;

  @override
  void initState() {
    id = widget.chatData!.id;

    setState(() {
      (() async {
        channel = IOWebSocketChannel.connect(
          "${Config.socketUrl}/rooms/chat/${widget.chatData?.id}",
          headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ${await firebaseAuth.currentUser?.getIdToken()}',
          },
        );
        channel!.stream.listen((event) {
          print(event);
        }, onError: (error) {
          print("Error : $error");
        });
      })();
    });

    super.initState();
  }

  @override
  void dispose() {
    channel?.innerWebSocket?.close();
    super.dispose();
  }

  var cursor = "";

  @override
  Widget build(BuildContext context) {
    cursor == "" ? DateTime.now().toIso8601String() : cursor;

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
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: apiService.getUserMessage(roomId: id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
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
                                      // color: (messages[index].messageType == "receiver"
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
          // Flexible(
          //   child: FutureBuilder<List<ChatMessage>>(
          //     future: apiService.getUserMessage(roomId: id),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         if (snapshot.hasData) {
          //           var data = snapshot.data;
          //           return data!.isEmpty
          //               ? const Center(
          //                   child: Text('Start a conversation !!!'),
          //                 )
          //               : ListView.builder(
          //                   itemCount: data.length,
          //                   shrinkWrap: true,
          //                   padding: const EdgeInsets.only(top: 10, bottom: 10),
          //                   // physics: const NeverScrollableScrollPhysics(),
          //                   itemBuilder: (context, index) {
          //                     return Container(
          //                       padding: const EdgeInsets.only(
          //                           left: 14, right: 14, top: 10, bottom: 10),
          //                       child: Align(
          //                         // alignment: (messages[index].messageType == "receiver"
          //                         alignment: (data[index].userId !=
          //                                 firebaseAuth.currentUser!.uid
          //                             ? Alignment.topLeft
          //                             : Alignment.topRight),
          //                         child: Container(
          //                           decoration: BoxDecoration(
          //                             borderRadius: BorderRadius.circular(20),
          //                             // color: (messages[index].messageType == "receiver"
          //                             color: (data[index].userId !=
          //                                     firebaseAuth.currentUser!.uid
          //                                 ? Colors.grey.shade200
          //                                 : Colors.blue[200]),
          //                           ),
          //                           padding: const EdgeInsets.all(16),
          //                           child: Text(
          //                             data[index].text!,
          //                             style: const TextStyle(fontSize: 15),
          //                           ),
          //                         ),
          //                       ),
          //                     );
          //                   },
          //                 );
          //         } else if (snapshot.hasError) {
          //           return Center(
          //             child: Text(snapshot.error.toString()),
          //           );
          //         }
          //       }
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     },
          //   ),
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
                    onPressed: () async {
                      setState(() {});
                      channel?.innerWebSocket?.add(messageController.text);
                      // await apiService.createUserMessage(
                      //     roomId: widget.chatData?.id,
                      //     chatMessage:
                      //         ChatMessage(text: messageController.text));
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
