import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/tenant/chat_detail_screen.dart';
import 'package:smart_rental_app/screens/tenant/chat_manager.dart';

class TenantChatTab extends StatefulWidget {
  const TenantChatTab({super.key});

  @override
  State<TenantChatTab> createState() => _TenantChatTabState();
}

class _TenantChatTabState extends State<TenantChatTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> bookings = [
    {
      'propertyTitle': 'Luxury Condo',
      'location': 'KLCC, Kuala Lumpur',
      'image': 'images/condo1.jpg',
      'date': '12 Apr 2026',
      'status': 'Successful',
      'price': 'RM 178/night',
      'checkIn': '15 Apr 2026',
      'checkOut': '17 Apr 2026',
      'guests': '2 Guests',
    },
    {
      'propertyTitle': 'Modern Studio',
      'location': 'Mont Kiara, Kuala Lumpur',
      'image': 'images/studio1.jpg',
      'date': '18 Apr 2026',
      'status': 'Pending',
      'price': 'RM 120/night',
      'checkIn': '22 Apr 2026',
      'checkOut': '24 Apr 2026',
      'guests': '1 Guest',
    },
    {
      'propertyTitle': 'Cozy Apartment',
      'location': 'Shah Alam, Selangor',
      'image': 'images/apartment1.jpg',
      'date': '20 Apr 2026',
      'status': 'Unsuccessful',
      'price': 'RM 95/night',
      'checkIn': '25 Apr 2026',
      'checkOut': '26 Apr 2026',
      'guests': '3 Guests',
    },
  ];

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
    final chats = ChatManager.chats;
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
                    chats.isEmpty
                        ? _buildEmptyChatState(context, dark)
                        : _buildChatList(chats, dark),
                    bookings.isEmpty
                        ? _buildEmptyBookingState(context, dark)
                        : _buildBookingList(dark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildChatList(List<dynamic> chats, bool dark) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        final messages = chat['messages'] as List<dynamic>;
        final lastMessage = messages.isNotEmpty ? messages.last['text'] : '';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatDetailScreen(chat: chat)),
            ).then((_) {
              if (!mounted) return;
              setState(() {});
            });
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      chat['propertyImage'] != null &&
                          chat['propertyImage'].toString().isNotEmpty
                      ? Image.asset(
                          chat['propertyImage'],
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _fallbackImage(dark);
                          },
                        )
                      : _fallbackImage(dark),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat['landlord'] ?? 'Landlord',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildBookingList(bool dark) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

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
              color: dark ? Colors.white.withOpacity(0.06) : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      booking['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _fallbackImage(dark, width: 60, height: 60);
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['propertyTitle'],
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking['location'],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: dark
                                ? Colors.white54
                                : const Color(0xFF9A8B78),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Booked on ${booking['date']}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: dark
                                ? Colors.white70
                                : const Color(0xFF6F5A40),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(booking['status']),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    booking['price'],
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB17B30),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _showBookingDetails(booking),
                    child: Text(
                      'View Details',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB17B30),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: dark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          booking['propertyTitle'],
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Location', booking['location'], dark),
            _detailRow('Booking Date', booking['date'], dark),
            _detailRow('Check In', booking['checkIn'], dark),
            _detailRow('Check Out', booking['checkOut'], dark),
            _detailRow('Guests', booking['guests'], dark),
            _detailRow('Price', booking['price'], dark),
            _detailRow('Status', booking['status'], dark),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: const Color(0xFFB17B30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, bool dark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.inter(
            fontSize: 13,
            color: dark ? Colors.white70 : const Color(0xFF5E4B36),
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color textColor;

    switch (status) {
      case 'Successful':
        bg = Colors.green.withOpacity(0.12);
        textColor = Colors.green;
        break;
      case 'Pending':
        bg = Colors.orange.withOpacity(0.12);
        textColor = Colors.orange;
        break;
      default:
        bg = Colors.red.withOpacity(0.12);
        textColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _fallbackImage(bool dark, {double width = 55, double height = 55}) {
    return Container(
      width: width,
      height: height,
      color: dark ? const Color(0xFF2A2A2A) : const Color(0xFFF3E8D7),
      child: const Icon(Icons.home_rounded, color: Color(0xFFB17B30)),
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
