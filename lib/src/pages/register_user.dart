import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../app.dart';
import '../config/firebase/auth.dart';
import '../core/utils/snack_bar.dart';
import '../injector.dart';
import '../models/user/user.dart';
import '../providers/auth_provider.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  static const String routeName = "register";

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visibility = true;

  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FormBuilder(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                firebaseAuth.currentUser != null
                    ? Center(
                        child: Column(
                          children: [
                            Text("${firebaseAuth.currentUser?.displayName}"),
                            IconButton(
                              onPressed: () {
                                firebaseAuth.signOut();
                              },
                              icon: const Icon(Icons.power_settings_new),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                const Center(
                  child: Text("Register Screen"),
                ),
                FormBuilderTextField(
                  name: "name",
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                  validator:
                      FormBuilderValidators.required(errorText: "Required"),
                ),
                FormBuilderTextField(
                  name: "email",
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Required"),
                    FormBuilderValidators.email(
                        errorText: "Enter a valid email"),
                  ]),
                ),
                FormBuilderTextField(
                  name: "password",
                  decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            visibility = !visibility;
                          });
                        },
                        icon: visibility
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      )),
                  obscureText: visibility,
                  validator:
                      FormBuilderValidators.required(errorText: "Required"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState?.save();
                      final userdata = User(
                        email: formKey.currentState?.value['email'],
                        name: formKey.currentState?.value['name'],
                        password: formKey.currentState?.value['password'],
                        id: "",
                      );

                      await apiService
                          .createUser(
                        data: userdata,
                      )
                          .then((value) {
                        firebaseAuth.signInWithEmailAndPassword(
                          email: userdata.email,
                          password: userdata.password!,
                        );
                      });
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
