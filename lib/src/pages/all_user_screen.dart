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

  Stream<List<GetAllUserResponseData>> userData =
      apiService.getAllUser(keyword: "").asStream().asBroadcastStream();

  loadData() async {
    setState(() {
      userData = apiService
          .getAllUser(keyword: searchController.text)
          .asStream()
          .asBroadcastStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: FormBuilderTextField(
                name: "search",
                textInputAction: TextInputAction.search,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search for users",
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      loadData();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                onEditingComplete: () {
                  loadData();
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<List<GetAllUserResponseData>>(
                  stream: userData,
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
                                      onPressed: () async {
                                        if (data[index].followStatus == true) {
                                          await apiService.unFollowUser(
                                            userID: data[index].id!,
                                          );
                                        } else {
                                          await apiService.followUser(
                                            userId: data[index].id!,
                                          );
                                        }
                                        loadData();
                                      },
                                      icon: data[index].followStatus == true
                                          ? const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.add,
                                              color: Colors.blue,
                                            ),
                                    ),
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
