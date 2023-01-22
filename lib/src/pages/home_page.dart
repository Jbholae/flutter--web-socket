import 'package:flutter/material.dart';
import 'package:web_socket_test/src/pages/all_user_screen.dart';

import 'register_user.dart';
import 'rooms.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    _callPage(int current) {
      switch (current) {
        case 0:
          return const RoomsScreen();
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
