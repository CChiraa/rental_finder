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
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: chats.isEmpty
              ? _buildEmptyState(context, dark)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Chats',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Talk to landlords directly here.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: dark ? Colors.white70 : const Color(0xFF6F5A40),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                                setState(() {});
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: dark
                                    ? const Color(0xFF1E1E1E)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: dark
                                        ? Colors.black.withOpacity(0.18)
                                        : Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                  color: dark
                                      ? Colors.white.withOpacity(0.06)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                children: [
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
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    width: 55,
                                                    height: 55,
                                                    color: dark
                                                        ? const Color(
                                                            0xFF2A2A2A,
                                                          )
                                                        : const Color(
                                                            0xFFF3E8D7,
                                                          ),
                                                    child: const Icon(
                                                      Icons.home,
                                                      color: Color(0xFFB17B30),
                                                    ),
                                                  );
                                                },
                                          )
                                        : Container(
                                            width: 55,
                                            height: 55,
                                            color: dark
                                                ? const Color(0xFF2A2A2A)
                                                : const Color(0xFFF3E8D7),
                                            child: const Icon(
                                              Icons.home,
                                              color: Color(0xFFB17B30),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 14),
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
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          chat['propertyTitle'],
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: dark
                                                ? Colors.white54
                                                : const Color(0xFF9A8B78),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          lastMessage,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: dark
                                                ? Colors.white70
                                                : const Color(0xFF6F5A40),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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

  Widget _buildEmptyState(BuildContext context, bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Chats',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Talk to landlords directly here.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: dark ? Colors.white70 : const Color(0xFF6F5A40),
          ),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Start chatting from a property',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: dark ? Colors.white54 : const Color(0xFF9A8B78),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
