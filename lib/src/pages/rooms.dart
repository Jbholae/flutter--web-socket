import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
  final formKey = GlobalKey<FormBuilderState>();

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
              return const CircularProgressIndicator();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog(
                  titlePadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  actionsPadding: const EdgeInsets.all(12),
                  title: const Text('Create Room'),
                  content: FormBuilder(
                    autoFocusOnValidationFailure: true,
                    key: formKey,
                    child: FormBuilderTextField(
                      name: 'room_name',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: "required"),
                      ]),
                      decoration: const InputDecoration(hintText: "Room Name"),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith((states) =>
                            Theme.of(context).errorColor.withAlpha(50)),
                      ),
                      child: Text(
                        'Cancel',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: Theme.of(context).errorColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          final response = await apiService.createRoom(
                            request: ChatRoom(
                              id: 0,
                              name: formKey.currentState!.value["room_name"],
                            ),
                          );
                          showSuccess(message: response.data['msg']);
                          setState(() {
                            myFuture = apiService.getUserRoom();
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text(
                        'Confirm',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    )
                  ],
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
