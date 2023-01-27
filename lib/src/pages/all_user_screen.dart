import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../injector.dart';
import '../models/user/get_all_user_response.dart/get_all_user_response.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  TextEditingController searchController = TextEditingController();

  Future<List<GetAllUserResponseData>>? userData;

  @override
  void initState() {
    loadData(searchController.text);
    super.initState();
  }

  loadData(String? keyword) async {
    userData = apiService.getAllUser(keyword: keyword);
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: FormBuilderTextField(
                  textInputAction: TextInputAction.search,
                  name: "search",
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search for users",
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchController.clear();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  onChanged: (value) {
                    loadData(value!);
                    setState(() {
                      userData = apiService.getAllUser(keyword: value);
                    });
                  },
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: FutureBuilder<List<GetAllUserResponseData>>(
                  future: userData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        var data = snapshot.data;
                        return data!.isEmpty
                            ? const Center(
                                child: Text('No User Found !!!'),
                              )
                            : ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: const CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://randomuser.me/api/portraits/men/4.jpg"),
                                      maxRadius: 20,
                                    ),
                                    title: Text(data[index].fullName!),
                                    subtitle: Text(data[index].email!),
                                    trailing: IconButton(
                                        onPressed: () {
                                          apiService.followUser(
                                            userId: data[index].id!,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.blue,
                                        )),
                                  );
                                },
                              );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
