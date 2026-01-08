import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'qr_scanner_screen.dart';
import 'banner_ad_widget.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final currentUser = FirebaseAuth.instance.currentUser!;

    // 🔹 Replace names if you want. UIDs are from your Firebase Auth users
    final users = [
      {"name": "User1", "uid": "eQZHxOoD3GTWDkaFGtOBRjw4Tgj1"},
      {"name": "User2", "uid": "r2Tq9rEQhCPNfvoyHrM569aURQi1"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
            },
          )
        ],
      ),
      body: Column(
        children: [
          // 🔹 QR SCANNER BUTTON
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: const Text("Scan QR Code"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QRScannerScreen(),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // 🔹 USERS LIST TO START CHAT
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                // Don't show the current logged-in user
                if (user["uid"] == currentUser.uid) return const SizedBox();

                return ListTile(
                  title: Text(user["name"]!),
                  leading: const Icon(Icons.person),
                  trailing: const Icon(Icons.chat),
                  onTap: () {
                    // Open chat screen with selected user
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
          ),

          // 🔹 ADMOB BANNER AT BOTTOM
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
