import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'qr_scanner_screen.dart';
import 'banner_ad_widget.dart';
import 'ai_chat_screen.dart';
import 'users_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => auth.logout(),
          )
        ],
      ),
      body: Column(
        children: [
          // 🔹 QR Scanner
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              child: const Text("Scan QR Code"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QRScannerScreen()),
                );
              },
            ),
          ),

          // 🔹 AI CHAT BUTTON
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.smart_toy),
              label: const Text("Chat with AI"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AIChatScreen()),
                );
              },
            ),
          ),

          // 🔹 USER CHAT BUTTON
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text("Chat with Users"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UsersListScreen()),
                );
              },
            ),
          ),

          const Spacer(),

          // 🔹 AdMob Banner
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
