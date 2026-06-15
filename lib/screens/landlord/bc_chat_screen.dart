import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/landlord/bc_chat_detail_screen.dart';
import 'package:smart_rental_app/services/chat_service.dart';

class BcChatScreen extends StatefulWidget {
  final bool dark;
  final Color glassCard;
  final Color glassBorder;

  const BcChatScreen({
    super.key,
    required this.dark,
    required this.glassCard,
    required this.glassBorder,
  });

  @override
  State<BcChatScreen> createState() => _BcChatScreenState();
}

class _BcChatScreenState extends State<BcChatScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = widget.dark
        ? Colors.white70
        : const Color(0xFF7B6243);
    final Color goldText = widget.dark
        ? const Color(0xFFE6BC6D)
        : const Color(0xFFC9A24A);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryText,
        title: Text(
          "Tenant Chats",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tap a tenant name to open the conversation.",
              style: GoogleFonts.inter(
                fontSize: 13.2,
                fontWeight: FontWeight.w500,
                color: secondaryText,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 18),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: user == null
                  ? null
                  : ChatService().getLandlordChats(user.uid),
              builder: (context, snapshot) {
                final docs = snapshot.data?.docs ?? [];
                final unreadCount = docs.where((doc) {
                  final chat = doc.data();
                  return (chat['landlordUnreadCount'] ?? 0) > 0 ||
                      (chat['unreadCount'] ?? 0) > 0;
                }).length;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.dark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.52),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: widget.dark
                          ? Colors.white.withOpacity(0.10)
                          : const Color(0xFFD6BC91).withOpacity(0.8),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.dark
                            ? Colors.black.withOpacity(0.16)
                            : const Color(0xFFD8AF5B).withOpacity(0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          title: "Chats",
                          value: docs.length.toString(),
                          icon: Icons.chat_bubble_outline_rounded,
                          color: const Color(0xFF00A86B),
                          dark: widget.dark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _summaryCard(
                          title: "Unread",
                          value: unreadCount.toString(),
                          icon: Icons.mark_chat_unread_rounded,
                          color: const Color(0xFFE53935),
                          dark: widget.dark,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 22),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chat List",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
                Text(
                  "Recent",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: goldText,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: user == null
                    ? null
                    : ChatService().getLandlordChats(user.uid),
                builder: (context, snapshot) {
                  if (user == null) {
                    return _buildEmptyState(context);
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final chat = docs[index].data();

                      final tenantName =
                          chat['tenantName']?.toString() ?? 'Tenant';
                      final propertyTitle =
                          chat['propertyTitle']?.toString() ?? 'Property';
                      final lastMessage =
                          chat['lastMessage']?.toString() ?? 'No messages yet';
                      final lastTime = chat['lastTime']?.toString() ?? '';

                      return InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LandlordChatDetailScreen(
                                chat: {
                                  'chatId': chat['chatId'] ?? docs[index].id,
                                  'tenantName': tenantName,
                                  'propertyTitle': propertyTitle,
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: widget.glassCard,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: widget.glassBorder),
                            boxShadow: [
                              BoxShadow(
                                color: widget.dark
                                    ? Colors.black.withOpacity(0.18)
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: const Color(
                                  0xFFC9A24A,
                                ).withOpacity(0.16),
                                child: Text(
                                  tenantName.isNotEmpty
                                      ? tenantName[0].toUpperCase()
                                      : 'T',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFC9A24A),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tenantName,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.8,
                                        color: widget.dark
                                            ? Colors.white
                                            : const Color(0xFF1D1D1F),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      propertyTitle,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.4,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFC9A24A),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.8,
                                        fontWeight: FontWeight.w500,
                                        color: widget.dark
                                            ? Colors.white70
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    lastTime,
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: widget.dark
                                          ? Colors.white54
                                          : const Color(0xFF9A8B78),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: Color(0xFFC9A24A),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool dark,
  }) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.42),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.08)
              : const Color(0xFFD9BC8A).withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: dark ? Colors.white : const Color(0xFF1D1D1F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12.4,
                    fontWeight: FontWeight.w500,
                    color: dark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = widget.dark
        ? Colors.white54
        : const Color(0xFF9A8B78);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 58,
            color: Color(0xFFC9A24A),
          ),
          const SizedBox(height: 12),
          Text(
            "No tenant chats yet",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Tenant conversations will appear here.",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
