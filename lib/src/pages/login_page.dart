import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Center,
        Column,
        Container,
        EdgeInsets,
        ElevatedButton,
        GlobalKey,
        Icon,
        IconButton,
        Icons,
        InputDecoration,
        MainAxisAlignment,
        Navigator,
        Padding,
        Row,
        SafeArea,
        Scaffold,
        State,
        StatefulWidget,
        Text,
        Theme,
        Widget;
import 'package:flutter_form_builder/flutter_form_builder.dart'
    show FormBuilder, FormBuilderState, FormBuilderTextField;
import 'package:form_builder_validators/form_builder_validators.dart'
    show FormBuilderValidators;

import '../config/firebase/auth.dart';
import '../core/utils/snack_bar.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "login";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormBuilderState>();
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
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      await firebaseAuth.signInWithEmailAndPassword(
                        email: formKey.currentState?.value['email'],
                        password: formKey.currentState?.value['password'],
                      );
                    } on FirebaseAuthException catch (e) {
                      showError(message: e.message ?? "");
                    }
                  }
                },
                child: const Text('Login'),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(RegisterPage.routeName),
                      child: const Text("Create"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
