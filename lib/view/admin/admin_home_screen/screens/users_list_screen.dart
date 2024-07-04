import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitr/firebase_functions.dart';
import 'package:gitr/model/user.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  var usersList = <UserModel>[].obs;

  Future<void> loadUsers() async {
    List<UserModel> allUsers = await FirebaseFunctions.getAllUsers();
    usersList.addAll(allUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return ListView.separated(
          itemCount: usersList.length,
          itemBuilder: (context, index) {
            var user = usersList[index];
            return Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Text("Name  : ${user.name}"),
                    Text("Email : ${user.email}"),
                  ],
                ));
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        );
      }),
    );
  }
}
