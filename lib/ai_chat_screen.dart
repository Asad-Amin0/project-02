import 'package:flutter/material.dart';
import 'ai_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController controller = TextEditingController();
  final AIService aiService = AIService();
  String response = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Assistant")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Ask something...",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final reply = await aiService.sendMessage(controller.text);
                setState(() => response = reply);
              },
              child: const Text("Send"),
            ),
            const SizedBox(height: 20),
            Text(response),
          ],
        ),
      ),
    );
  }
}
