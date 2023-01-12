import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../app.dart';
import '../core/utils/snack_bar.dart';
import '../injector.dart';
import '../models/user/user.dart';
import '../providers/auth_provider.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

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
                      print('valid');
                      final response = await apiService.createUser(
                          data: User(
                        email: formKey.currentState?.value['email'],
                        name: formKey.currentState?.value['name'],
                        password: formKey.currentState?.value['password'],
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
