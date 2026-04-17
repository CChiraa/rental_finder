import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final Map chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController controller = TextEditingController();

  void sendMessage() {
    if (controller.text.isEmpty) return;

    setState(() {
      widget.chat['messages'].add({'isMe': true, 'text': controller.text});
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.chat['messages'];

    return Scaffold(
      appBar: AppBar(title: Text(widget.chat['landlord'])),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg = messages[i];

                return Align(
                  alignment: msg['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg['isMe'] ? Colors.blue : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['text']),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(child: TextField(controller: controller)),
              IconButton(icon: const Icon(Icons.send), onPressed: sendMessage),
            ],
          ),
        ],
      ),
    );
  }
}
