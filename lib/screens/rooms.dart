import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_test/provider/user_chat_rooms.dart';
import 'package:web_socket_test/screens/chat_detail_page.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<UserChatRoomsProvider>(context).getChatRoom(1);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Consumer<UserChatRoomsProvider>(
              builder: (context, getRoom, child) {
            return getRoom.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: 20,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(width: 1),
                          ),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Expanded(
                                child: Text(
                                  index.toString(),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatDetailPage(
                                          name: index.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.meeting_room,
                                  ),
                                  label: const Text('Enter'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }),
        ),
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
                      const Flexible(
                        child: TextField(
                          decoration: InputDecoration(
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
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: const Text('Confirm'),
                            ),
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
