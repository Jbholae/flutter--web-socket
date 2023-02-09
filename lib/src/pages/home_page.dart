import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../../config.dart';
import '../injector.dart';
import 'all_user_screen.dart';
import 'register_user.dart';
import 'rooms.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  final IOWebSocketChannel channel = IOWebSocketChannel.connect(
    "${Config.socketUrl}/users/notify",
    headers: {
      HttpHeaders.authorizationHeader:
      'Bearer ${sharedPreferences.getString('token')}',
    },
  );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  _callPage(int current) {
    switch (current) {
      case 0:
        return RoomsScreen(channel: widget.channel);
      case 1:
        return const RegisterUser();
      case 2:
        return const AllUserScreen();
      default:
    }
  }

  void onTapped(int index) {
    _currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _callPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: "Rooms",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_rounded),
            label: "Friends",
          ),
        ],
      ),
    );
  }
}
