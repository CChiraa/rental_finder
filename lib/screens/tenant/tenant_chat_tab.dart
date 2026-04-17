import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/tenant/chat_manager.dart';
import 'package:smart_rental_app/screens/tenant/chat_detail_screen.dart';

class TenantChatTab extends StatefulWidget {
  const TenantChatTab({super.key});

  @override
  State<TenantChatTab> createState() => _TenantChatTabState();
}

class _TenantChatTabState extends State<TenantChatTab> {
  @override
  Widget build(BuildContext context) {
    final chats = ChatManager.chats;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: chats.isEmpty
              ? _buildEmptyState()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    /// 🔷 TITLE
                    Text(
                      'Chats',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2B2118),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Talk to landlords directly here.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF6F5A40),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔷 CHAT LIST
                    Expanded(
                      child: ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          final chat = chats[index];

                          final messages = chat['messages'] as List<dynamic>;
                          final lastMessage = messages.isNotEmpty
                              ? messages.last['text']
                              : '';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatDetailScreen(chat: chat),
                                ),
                              ).then((_) {
                                setState(() {}); // refresh after return
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  /// 🔷 PROPERTY IMAGE
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        chat['propertyImage'] != null &&
                                            chat['propertyImage']
                                                .toString()
                                                .isNotEmpty
                                        ? Image.asset(
                                            chat['propertyImage'],
                                            width: 55,
                                            height: 55,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: 55,
                                            height: 55,
                                            color: const Color(0xFFF3E8D7),
                                            child: const Icon(
                                              Icons.home,
                                              color: Color(0xFFB17B30),
                                            ),
                                          ),
                                  ),

                                  const SizedBox(width: 14),

                                  /// 🔷 CHAT INFO
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          chat['landlord'],
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          chat['propertyTitle'],
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: const Color(0xFF9A8B78),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          lastMessage,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: const Color(0xFF6F5A40),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// 🔷 ICON
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Color(0xFFB17B30),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  /// 🔷 EMPTY STATE UI
  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        Text(
          'Chats',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2B2118),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Talk to landlords directly here.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF6F5A40),
          ),
        ),

        const SizedBox(height: 40),

        Center(
          child: Column(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                size: 60,
                color: Color(0xFFB17B30),
              ),
              const SizedBox(height: 12),
              Text(
                'No chats yet',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Start chatting from a property',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF9A8B78),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
