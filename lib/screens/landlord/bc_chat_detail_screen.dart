import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_rental_app/screens/landlord/bc_chat_manager.dart';

class LandlordChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chat;

  const LandlordChatDetailScreen({super.key, required this.chat});

  @override
  State<LandlordChatDetailScreen> createState() =>
      _LandlordChatDetailScreenState();
}

class _LandlordChatDetailScreenState extends State<LandlordChatDetailScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();

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

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      LandlordChatManager.sendMessage(widget.chat, text);
    });

    messageController.clear();
    _scrollToBottom();
  }

  Future<void> _pickFromCamera() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      LandlordChatManager.sendImageMessage(widget.chat, image.path);
    });

    _scrollToBottom();
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      LandlordChatManager.sendImageMessage(widget.chat, image.path);
    });

    _scrollToBottom();
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF8F1E7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_rounded,
                    color: Color(0xFFC9A24A),
                  ),
                  title: Text(
                    'Take Photo',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_rounded,
                    color: Color(0xFFC9A24A),
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = List<Map<String, dynamic>>.from(
      widget.chat['messages'] ?? [],
    );

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
                (widget.chat['tenantName'] ?? 'T').toString()[0].toUpperCase(),
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
                    widget.chat['tenantName'] ?? 'Tenant',
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
                          errorBuilder: (_, __, ___) {
                            return Container(
                              width: 54,
                              height: 54,
                              color: const Color(0xFFF3E8D7),
                              child: const Icon(
                                Icons.home_work_rounded,
                                color: Color(0xFFC9A24A),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 54,
                          height: 54,
                          color: const Color(0xFFF3E8D7),
                          child: const Icon(
                            Icons.home_work_rounded,
                            color: Color(0xFFC9A24A),
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Chatting about ${widget.chat['propertyTitle']}',
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
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final bool isMe = message['isMe'] ?? false;
                final String text = message['text'] ?? '';
                final String? imagePath = message['imagePath'];

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
                          ? const Color(0xFFC9A24A)
                          : Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMe ? 18 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (imagePath != null && imagePath.isNotEmpty) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              File(imagePath),
                              width: 190,
                              height: 190,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (text.isNotEmpty) const SizedBox(height: 8),
                        ],
                        if (text.isNotEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
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
                        const SizedBox(height: 4),
                        Text(
                          message['time'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isMe
                                ? Colors.white70
                                : const Color(0xFF9A8B78),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    onPressed: _showImageOptions,
                    icon: const Icon(
                      Icons.add_photo_alternate_rounded,
                      color: Color(0xFFC9A24A),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Reply to tenant...',
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
                    color: Color(0xFFC9A24A),
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
