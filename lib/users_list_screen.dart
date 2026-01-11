import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    final users = [
      {"name": "User 1", "uid": "eQZHxOoD3GTWDkaFGtOBRjw4Tgj1"},
      {"name": "User 2", "uid": "r2Tq9rEQhCPNfvoyHrM569aURQi1"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          if (user["uid"] == currentUser.uid) {
            return const SizedBox();
          }

          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(user["name"]!),
            trailing: const Icon(Icons.chat),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    receiverId: user["uid"]!,
                    receiverName: user["name"]!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
