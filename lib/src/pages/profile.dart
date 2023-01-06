import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app.dart';
import '../core/utils/snack_bar.dart';
import '../injector.dart';
import '../models/user/user.dart';
import '../providers/auth_provider.dart';

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
                      final response = await apiService.createUser(
                          data: User(
                        email: emailController.text,
                        name: nameController.text,
                        id: 0,
                      ));
                      final data = response.data as Map<String, dynamic>;

                      if (data.containsKey("data")) {
                        Provider.of<AuthProvider>(context, listen: false)
                            .setAuthUser(User.fromJson(data["data"]));
                        mainNavigator.currentState?.pushNamed("/");
                        showSuccess(message: data["data"]);
                      } else if (data.containsKey("error")) {
                        showError(message: data["error"]);
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
