import 'package:flutter/material.dart';
import 'package:flutter_skeleton/src/core/utils/api_error.dart';
import 'package:flutter_skeleton/src/core/utils/snack_bar.dart';
import 'package:flutter_skeleton/src/services/app_repo.dart';
import 'package:flutter_skeleton/src/services/app_services.dart';
import 'package:flutter_skeleton/src/models/user/create_user/create_user_request.dart';
import 'package:flutter_skeleton/src/models/user/create_user/create_user_response.dart';
import 'package:provider/provider.dart';

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
    AppRepo? appRepo;

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
                      CreateUserRequest request = CreateUserRequest(
                        email: emailController.text,
                        name: nameController.text,
                      );
                      final response = await AppRepoImplementation()
                          .createUser(request: request);

                      if (response is CreateUserResponse) {
                        showSuccess(message: "Yeah");
                      } else if (response is APIError) {
                        showError(message: response.error.toString());
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
