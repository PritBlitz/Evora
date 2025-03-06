import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.add({"user": message});
      _isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Authorization": "", // Replace with new key
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": message}
          ]
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var botMessage = data["choices"][0]["message"]["content"];

        setState(() {
          _messages.add({"bot": botMessage});
        });
      } else if (response.statusCode == 429) {
        setState(() {
          _messages.add({
            "bot":
                "⚠️ Free trial limit reached! Please subscribe to continue using the chatbot."
          });
        });
      } else {
        setState(() {
          _messages.add({"bot": "Error: ${response.body}"});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"bot": "Error: $e"});
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                bool isUser = message.containsKey("user");
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isUser ? message["user"]! : message["bot"]!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _sendMessage(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
