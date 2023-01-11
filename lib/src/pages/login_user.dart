import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../app.dart';
import '../config/firebase/auth.dart';
import '../core/utils/snack_bar.dart';
import '../providers/auth_provider.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final formKey = GlobalKey<FormBuilderState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FormBuilder(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Center(
                child: Text("Login Screen"),
              ),
              FormBuilderTextField(
                name: "email",
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "required"),
                  FormBuilderValidators.email(),
                ]),
              ),
              FormBuilderTextField(
                name: "password",
                controller: passwordController,
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
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "required"),
                ]),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      firebaseAuth
                          .signInWithEmailAndPassword(
                        email: formKey.currentState?.value['email'],
                        password: formKey.currentState?.value['password'],
                      )
                          .then((value) {
                        if (value.user != null) {
                          // Provider.of<AuthProvider>(context, listen: false);
                          mainNavigator.currentState?.pushNamed("/");
                        }
                      });
                      print("valid");
                    } on FirebaseAuthException catch (e) {
                      showError(message: e.toString());
                    }
                  }
                },
                child: const Text('Login'),
              )
            ],
          ),
        ),
      )),
    );
  }
}
