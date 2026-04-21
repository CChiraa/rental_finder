import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bc_booking_screen.dart';
import 'bc_payment_screen.dart';
import 'bc_chat_screen.dart';

class LandlordBookChatTab extends StatefulWidget {
  final bool dark;
  final Color glassCard;
  final Color glassBorder;

  const LandlordBookChatTab({
    super.key,
    required this.dark,
    required this.glassCard,
    required this.glassBorder,
  });

  @override
  State<LandlordBookChatTab> createState() => _LandlordBookChatTabState();
}

class _LandlordBookChatTabState extends State<LandlordBookChatTab> {
  int selectedSection = 0; // 0 bookings, 1 payments, 2 chats

  @override
  Widget build(BuildContext context) {
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = widget.dark
        ? Colors.white70
        : const Color(0xFF7B6243);
    final Color goldText = widget.dark
        ? const Color(0xFFE6BC6D)
        : const Color(0xFFC9A24A);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Book & Chat",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Approve bookings, review payment proof and respond to tenant conversations in one place.",
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: secondaryText,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          _buildOverviewSection(primaryText, secondaryText),

          const SizedBox(height: 22),

          _buildSectionTitle(
            title: "Manage",
            actionText: "Active Requests",
            primaryText: primaryText,
            actionColor: goldText,
          ),
          const SizedBox(height: 12),

          _buildTopToggle(),
          const SizedBox(height: 18),

          if (selectedSection == 0) ...[
            _sectionHint(
              title: "Booking Requests",
              subtitle:
                  "Review new booking requests and approve suitable stays.",
              secondaryText: secondaryText,
            ),
            const SizedBox(height: 12),
            _bookChatCard(
              context: context,
              screenType: BookChatScreenType.booking,
              title: "Booking Request",
              subtitle: "Aina wants to book Condo near KLCC",
              details: "24 Apr - 26 Apr • 2 guests",
              status: "Pending Approval",
              icon: Icons.approval_rounded,
              statusColor: const Color(0xFFFF9800),
              actionText: "Approve",
              dark: widget.dark,
              glassCard: widget.glassCard,
              glassBorder: widget.glassBorder,
            ),
            _bookChatCard(
              context: context,
              screenType: BookChatScreenType.booking,
              title: "Booking Request",
              subtitle: "Sara wants to stay at Cozy Family House",
              details: "30 Apr - 2 May • 4 guests",
              status: "New Request",
              icon: Icons.calendar_month_rounded,
              statusColor: const Color(0xFFC9A24A),
              actionText: "Review",
              dark: widget.dark,
              glassCard: widget.glassCard,
              glassBorder: widget.glassBorder,
            ),
          ] else if (selectedSection == 1) ...[
            _sectionHint(
              title: "Payment Review",
              subtitle: "Check uploaded receipts and verify tenant payments.",
              secondaryText: secondaryText,
            ),
            const SizedBox(height: 12),
            _bookChatCard(
              context: context,
              screenType: BookChatScreenType.payment,
              title: "Payment Request",
              subtitle: "Receipt uploaded for Studio Apartment",
              details: "Tenant: Daniel • RM120 paid",
              status: "Review Payment",
              icon: Icons.receipt_long_rounded,
              statusColor: const Color(0xFF355CDE),
              actionText: "Verify",
              dark: widget.dark,
              glassCard: widget.glassCard,
              glassBorder: widget.glassBorder,
            ),
            _bookChatCard(
              context: context,
              screenType: BookChatScreenType.payment,
              title: "Payment Request",
              subtitle: "Proof sent for Condo near KLCC",
              details: "Tenant: Aina • RM178 paid",
              status: "Awaiting Confirmation",
              icon: Icons.payments_rounded,
              statusColor: const Color(0xFFFF9800),
              actionText: "Check",
              dark: widget.dark,
              glassCard: widget.glassCard,
              glassBorder: widget.glassBorder,
            ),
          ] else ...[
            _sectionHint(
              title: "Tenant Chats",
              subtitle:
                  "Reply to questions, coordinate bookings and provide updates.",
              secondaryText: secondaryText,
            ),
            const SizedBox(height: 12),
            _bookChatCard(
              context: context,
              screenType: BookChatScreenType.chat,
              title: "Tenant Chat",
              subtitle: "New message from Daniel",
              details: "Asked about parking availability",
              status: "Open Chat",
              icon: Icons.chat_bubble_outline_rounded,
              statusColor: const Color(0xFF00A86B),
              actionText: "Reply",
              dark: widget.dark,
              glassCard: widget.glassCard,
              glassBorder: widget.glassBorder,
            ),
            _bookChatCard(
              context: context,
              screenType: BookChatScreenType.chat,
              title: "Tenant Chat",
              subtitle: "Aina replied about check-in time",
              details: "Last message: 12 mins ago",
              status: "Unread",
              icon: Icons.mark_chat_unread_rounded,
              statusColor: const Color(0xFFE53935),
              actionText: "Open",
              dark: widget.dark,
              glassCard: widget.glassCard,
              glassBorder: widget.glassBorder,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOverviewSection(Color primaryText, Color secondaryText) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title: "Overview", primaryText: primaryText),
          const SizedBox(height: 8),
          Text(
            "Current activity across bookings, payments and tenant chats",
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  title: "Bookings",
                  value: "4",
                  icon: Icons.book_online_rounded,
                  color: const Color(0xFFC9A24A),
                  dark: widget.dark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  title: "Payments",
                  value: "2",
                  icon: Icons.receipt_long_rounded,
                  color: const Color(0xFF355CDE),
                  dark: widget.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  title: "Chats",
                  value: "6",
                  icon: Icons.chat_bubble_outline_rounded,
                  color: const Color(0xFF00A86B),
                  dark: widget.dark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  title: "Unread",
                  value: "3",
                  icon: Icons.mark_chat_unread_rounded,
                  color: const Color(0xFFE53935),
                  dark: widget.dark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopToggle() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: widget.glassCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.glassBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _toggleButton(
              title: "Bookings",
              selected: selectedSection == 0,
              onTap: () {
                setState(() {
                  selectedSection = 0;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _toggleButton(
              title: "Payments",
              selected: selectedSection == 1,
              onTap: () {
                setState(() {
                  selectedSection = 1;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _toggleButton(
              title: "Chats",
              selected: selectedSection == 2,
              onTap: () {
                setState(() {
                  selectedSection = 2;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected ? const Color(0xFFC9A24A) : Colors.transparent,
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: selected
                  ? Colors.white
                  : (widget.dark ? Colors.white70 : const Color(0xFF5C4630)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHint({
    required String title,
    required String subtitle,
    required Color secondaryText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: widget.dark
            ? Colors.white.withOpacity(0.04)
            : Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13.8,
              fontWeight: FontWeight.w700,
              color: widget.dark ? Colors.white : const Color(0xFF2B2118),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12.4,
              fontWeight: FontWeight.w500,
              color: secondaryText,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required Color primaryText,
    String? actionText,
    Color? actionColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        if (actionText != null && actionText.trim().isNotEmpty)
          Text(
            actionText,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: actionColor ?? const Color(0xFFC9A24A),
            ),
          ),
      ],
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
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.42),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.08)
              : const Color(0xFFD9BC8A).withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
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
                    fontSize: 12.6,
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
}

enum BookChatScreenType { booking, payment, chat }

Widget _bookChatCard({
  required BuildContext context,
  required BookChatScreenType screenType,
  required String title,
  required String subtitle,
  required String details,
  required String status,
  required IconData icon,
  required Color statusColor,
  required String actionText,
  required bool dark,
  required Color glassCard,
  required Color glassBorder,
}) {
  void openScreen() {
    Widget screen;

    switch (screenType) {
      case BookChatScreenType.booking:
        screen = BcBookingScreen(
          dark: dark,
          glassCard: glassCard,
          glassBorder: glassBorder,
        );
        break;
      case BookChatScreenType.payment:
        screen = BcPaymentScreen(
          dark: dark,
          glassCard: glassCard,
          glassBorder: glassBorder,
        );
        break;
      case BookChatScreenType.chat:
        screen = BcChatScreen(
          dark: dark,
          glassCard: glassCard,
          glassBorder: glassBorder,
        );
        break;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: glassCard,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: glassBorder),
      boxShadow: [
        BoxShadow(
          color: dark
              ? Colors.black.withOpacity(0.18)
              : Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: openScreen,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: statusColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.8,
                        color: dark ? Colors.white : const Color(0xFF1D1D1F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: dark ? Colors.white70 : Colors.grey.shade700,
                        fontSize: 12.8,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      details,
                      style: GoogleFonts.inter(
                        color: dark
                            ? const Color(0xFFE6BC6D)
                            : const Color(0xFFC9A24A),
                        fontSize: 12.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.8,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: openScreen,
                style: OutlinedButton.styleFrom(
                  foregroundColor: dark
                      ? Colors.white70
                      : const Color(0xFF5C4630),
                  side: BorderSide(color: glassBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text(
                  "View Details",
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: openScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC9A24A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text(
                  actionText,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
