import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Center(
                child: Text("Profile Screen"),
              ),
              const TextField(
                decoration: InputDecoration(
                  label: Text('Name'),
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  label: Text('Email'),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Create'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
