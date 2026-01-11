import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // Replace with your actual API key
  static const String apiKey = "AIzaSyBO-rJTMj-aTvnKnKJD_YjPr5KZS_ZZifE";

  Future<String> sendMessage(String userMessage) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta2/models/gemini-1:generateText?key=$apiKey",
    );

    final body = {
      "prompt": {
        "text": userMessage
      },
      "temperature": 0.7,
      "maxOutputTokens": 256
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // The structure may vary, check "candidates" or "output" key
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['output'] ?? "No response";
      } else if (data['output'] != null) {
        return data['output'][0]['content'] ?? "No response";
      } else {
        return "AI returned empty response.";
      }
    } else {
      print("AI API Error: ${response.statusCode} - ${response.body}");
      return "Error ${response.statusCode}: ${response.body}";
    }
  }
}
