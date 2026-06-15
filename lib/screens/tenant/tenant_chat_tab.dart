import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/tenant/chat_detail_screen.dart';
import 'package:smart_rental_app/services/booking_service.dart';
import 'package:smart_rental_app/services/chat_service.dart';

class TenantChatTab extends StatefulWidget {
  const TenantChatTab({super.key});

  @override
  State<TenantChatTab> createState() => _TenantChatTabState();
}

class _TenantChatTabState extends State<TenantChatTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF6F5A40);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chat & Book',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your conversations and booking history here.',
                style: GoogleFonts.inter(fontSize: 14, color: secondaryText),
              ),
              const SizedBox(height: 20),

              Container(
                height: 54,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: dark
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFFF3E8D7),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: dark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTopTabButton(
                        title: 'Chat',
                        selected: _tabController.index == 0,
                        onTap: () {
                          _tabController.animateTo(0);
                          setState(() {});
                        },
                        dark: dark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTopTabButton(
                        title: 'Book',
                        selected: _tabController.index == 1,
                        onTap: () {
                          _tabController.animateTo(1);
                          setState(() {});
                        },
                        dark: dark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildChatList(dark),
                    _buildFirestoreBookingList(dark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList(bool dark) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseAuth.instance.currentUser == null
          ? null
          : ChatService().getTenantChats(
              FirebaseAuth.instance.currentUser!.uid,
            ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return _buildEmptyChatState(context, dark);
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final chat = docs[index].data();

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatDetailScreen(
                      chat: {
                        'chatId': chat['chatId'],
                        'landlord': chat['landlordName'],
                        'propertyTitle': chat['propertyTitle'],
                        'propertyImage': chat['propertyImage'],
                      },
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: dark ? const Color(0xFF1E1E1E) : Colors.white,
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
                    const CircleAvatar(
                      backgroundColor: Color(0xFFB17B30),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat['landlordName'] ?? 'Landlord',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            chat['propertyTitle'] ?? 'Property',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: dark
                                  ? Colors.white70
                                  : const Color(0xFF6F5A40),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            chat['lastMessage'] ?? 'No messages yet',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: dark
                                  ? Colors.white54
                                  : const Color(0xFF9A8B78),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFirestoreBookingList(bool dark) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseAuth.instance.currentUser == null
          ? null
          : BookingService().getTenantBookings(
              FirebaseAuth.instance.currentUser!.uid,
            ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return _buildEmptyBookingState(context, dark);
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final booking = docs[index].data();

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: dark ? const Color(0xFF1E1E1E) : Colors.white,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['propertyTitle'] ?? 'Property',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check-in: ${booking['checkIn'] ?? '-'}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: dark ? Colors.white70 : const Color(0xFF5E4B36),
                    ),
                  ),
                  Text(
                    'Check-out: ${booking['checkOut'] ?? '-'}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: dark ? Colors.white70 : const Color(0xFF5E4B36),
                    ),
                  ),
                  if ((booking['price'] ?? '').toString().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      booking['price'].toString(),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB17B30),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  _statusBadge(booking['status'] ?? 'Pending'),

                  if ((booking['status'] ?? '').toString().toLowerCase() ==
                          'rejected' &&
                      (booking['rejectionReason'] ?? '')
                          .toString()
                          .isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.15)),
                      ),
                      child: Text(
                        'Reason: ${booking['rejectionReason']}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopTabButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    required bool dark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: double.infinity,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFB17B30) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected
                  ? Colors.white
                  : (dark ? Colors.white70 : const Color(0xFF7B5E35)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(dynamic status) {
    Color bg;
    Color textColor;

    switch (status.toString().toLowerCase()) {
      case 'successful':
      case 'approved':
        bg = Colors.green.withOpacity(0.12);
        textColor = Colors.green;
        break;
      case 'pending':
        bg = Colors.orange.withOpacity(0.12);
        textColor = Colors.orange;
        break;
      case 'rejected':
      case 'unsuccessful':
        bg = Colors.red.withOpacity(0.12);
        textColor = Colors.red;
        break;
      default:
        bg = Colors.grey.withOpacity(0.12);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status.toString(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildEmptyChatState(BuildContext context, bool dark) {
    return Center(
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
    );
  }

  Widget _buildEmptyBookingState(BuildContext context, bool dark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_month_outlined,
            size: 60,
            color: Color(0xFFB17B30),
          ),
          const SizedBox(height: 12),
          Text(
            'No bookings yet',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your booking history will appear here',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: dark ? Colors.white54 : const Color(0xFF9A8B78),
            ),
          ),
        ],
      ),
    );
  }
}
