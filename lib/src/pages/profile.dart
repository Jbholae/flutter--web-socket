import 'package:flutter/material.dart';

import '../core/utils/snack_bar.dart';
import '../models/user/create_user/create_user_request.dart';
import '../services/app_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
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
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Map<String, dynamic> response =
                          await AppRepoImplementation().createUser(
                              request: CreateUserRequest(
                        email: emailController.text,
                        name: nameController.text,
                      ));

                      if (response.containsKey("msg")) {
                        // TODO :: save user in local storage
                        // TODO :: Navigate to Room List Screen
                        showSuccess(message: response["msg"]);
                      } else if (response.containsKey("error")) {
                        showError(message: response["error"]);
                      }
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
