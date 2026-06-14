import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/services/chat_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage() async {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final chatId = widget.chat['chatId']?.toString();

    if (chatId == null || chatId.isEmpty) return;

    await ChatService().sendMessage(
      chatId: chatId,
      senderId: user.uid,
      senderName: user.displayName ?? 'Tenant',
      text: text,
    );

    messageController.clear();
    _scrollToBottom();
  }

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatId = widget.chat['chatId']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8F1E7),
        foregroundColor: const Color(0xFF2B2118),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFE6BC6D),
              child: Text(
                (widget.chat['landlord'] ?? 'L').toString()[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat['landlord'] ?? 'Landlord',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2B2118),
                    ),
                  ),
                  Text(
                    widget.chat['propertyTitle'] ?? 'Property',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF7B664C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      (widget.chat['propertyImage'] ?? '').toString().isNotEmpty
                      ? Image.asset(
                          widget.chat['propertyImage'],
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 54,
                          height: 54,
                          color: const Color(0xFFF3E8D7),
                          child: const Icon(
                            Icons.home_work_rounded,
                            color: Color(0xFFB17B30),
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Chatting about ${widget.chat['propertyTitle'] ?? 'this property'}',
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF5E4B36),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: chatId.isEmpty
                ? const Center(child: Text('Chat ID not found.'))
                : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: ChatService().getMessages(chatId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data!.docs;
                      final currentUser = FirebaseAuth.instance.currentUser;

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });

                      if (docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No messages yet. Start the conversation.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF7B664C),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final message = docs[index].data();

                          final bool isMe =
                              currentUser != null &&
                              message['senderId'] == currentUser.uid;

                          final String text = message['text']?.toString() ?? '';

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              constraints: const BoxConstraints(maxWidth: 260),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? const Color(0xFFB17B30)
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 18),
                                ),
                              ),
                              child: Text(
                                text,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: isMe
                                      ? Colors.white
                                      : const Color(0xFF2B2118),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.78),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: GoogleFonts.inter(
                        color: const Color(0xFF9B8A76),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFB17B30),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
