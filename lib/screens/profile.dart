import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_test/provider/create_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Provider.of<CreateUserProvider>(context);
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
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  label: Text('Email'),
                ),
              ),
              Consumer<CreateUserProvider>(
                  builder: (context, createUser, child) {
                return ElevatedButton(
                  onPressed: () {
                    createUser.createUser(
                      nameController.text,
                      emailController.text,
                    );
                  },
                  child: createUser.loading
                      ? const CircularProgressIndicator()
                      : const Text('Create'),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
