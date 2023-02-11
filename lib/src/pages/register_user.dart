import 'dart:io';

import 'package:dio/dio.dart' show DioError;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/material.dart'
    show
        AutovalidateMode,
        BuildContext,
        Center,
        Column,
        EdgeInsets,
        ElevatedButton,
        GlobalKey,
        Icon,
        IconButton,
        Icons,
        InputDecoration,
        Key,
        MainAxisAlignment,
        Padding,
        SafeArea,
        Scaffold,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:flutter_form_builder/flutter_form_builder.dart'
    show FormBuilder, FormBuilderState, FormBuilderTextField;
import 'package:form_builder_validators/form_builder_validators.dart'
    show FormBuilderValidators;
import 'package:provider/provider.dart' show Consumer;

import '../app.dart';
import '../config/firebase/auth.dart';
import '../core/utils/snack_bar.dart';
import '../injector.dart';
import '../models/user/user.dart';
import '../providers/auth_provider.dart';
import 'login_user.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  static const String routeName = "register";

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  bool visibility = true;

  final formKey = GlobalKey<FormBuilderState>();

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
                  child: Text("Register Screen"),
                ),
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: "full_name",
                  decoration: const InputDecoration(
                    hintText: "Full Name",
                  ),
                  validator:
                      FormBuilderValidators.required(errorText: "Required"),
                ),
                FormBuilderTextField(
                  name: "email",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        fullName: formKey.currentState?.value['full_name'],
                        password: formKey.currentState?.value['password'],
                      );

                      try {
                        final value =
                            await apiService.createUser(data: userdata);
                        if (value.statusCode == HttpStatus.created) {
                          await firebaseAuth.signInWithEmailAndPassword(
                            email: userdata.email,
                            password: userdata.password!,
                          );
                        }
                      } on DioError catch (e) {
                        showError(message: e.message);
                      } on FirebaseAuthException catch (e) {
                        showError(message: e.message ?? "");
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
                Consumer<AuthProvider>(builder: (ctx, value, _) {
                  if (!value.loggedIn) {
                    return ElevatedButton(
                      onPressed: () {
                        mainNavigator.currentState
                            ?.pushReplacementNamed(LoginUser.routeName);
                      },
                      child: const Text('Login'),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {
                      firebaseAuth.signOut();
                    },
                    child: const Text('Logout'),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
