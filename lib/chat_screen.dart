import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'banner_ad_widget.dart'; // Import your Banner Ad widget

class ChatScreen extends StatefulWidget {
  final String receiverId;   // UID of the person you chat with
  final String receiverName; // Name to show in AppBar

  const ChatScreen({super.key, required this.receiverId, required this.receiverName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _controller = TextEditingController();
  final DatabaseReference db = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> messages = [];
  late String chatId;

  @override
  void initState() {
    super.initState();

    // Create a consistent chat ID for the two users
    List<String> uids = [user.uid, widget.receiverId];
    uids.sort(); // ensures same chatId for both users
    chatId = uids.join("_");

    // Listen for messages in real-time
    db.child("chats/$chatId").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          // Convert each value to Map<String, dynamic> safely
          messages = data.values
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();

          // Sort by timestamp ascending
          messages.sort((a, b) => (a['timestamp'] as int).compareTo(b['timestamp'] as int));
        });
      } else {
        setState(() {
          messages = [];
        });
      }
    });
  }

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    db.child("chats/$chatId").push().set({
      "senderId": user.uid,
      "message": _controller.text.trim(),
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverName)),
      body: Column(
        children: [
          // 🔹 Message list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg["senderId"] == user.uid;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["message"] ?? '',
                      style: TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // 🔹 Input box
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),

          // 🔹 Optional: AdMob banner at the bottom
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
