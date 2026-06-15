import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/services/booking_service.dart';
import 'package:smart_rental_app/services/chat_service.dart';
import 'package:smart_rental_app/services/property_service.dart';

class LandlordHomeTab extends StatelessWidget {
  final String userName;
  final bool dark;
  final Color glassCard;
  final Color glassBorder;
  final Color primaryText;
  final Color secondaryText;
  final Color accentBlue;
  final VoidCallback onGoToAvailability;
  final VoidCallback onGoToAdd;
  final VoidCallback onGoToBookChat;
  final VoidCallback onGoToProfile;

  const LandlordHomeTab({
    super.key,
    required this.userName,
    required this.dark,
    required this.glassCard,
    required this.glassBorder,
    required this.primaryText,
    required this.secondaryText,
    required this.accentBlue,
    required this.onGoToAvailability,
    required this.onGoToAdd,
    required this.onGoToBookChat,
    required this.onGoToProfile,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please sign in again.'));
    }

    final landlordId = user.uid;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroWithCounts(landlordId),
          const SizedBox(height: 18),
          _buildInsightBanner(),
          const SizedBox(height: 22),
          _buildOverviewContainer(landlordId),
          const SizedBox(height: 24),
          _buildSectionTitle(
            title: "Quick Actions",
            actionText: "Manage",
            primaryText: primaryText,
            dark: dark,
          ),
          const SizedBox(height: 8),
          Text(
            "Shortcuts to manage landlord tasks",
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.02,
            children: [
              _buildActionCard(
                icon: Icons.add_business_rounded,
                title: "Add Property",
                subtitle: "Create a new listing",
                color: accentBlue,
                onTap: onGoToAdd,
              ),
              _buildActionCard(
                icon: Icons.calendar_month_rounded,
                title: "Availability",
                subtitle: "View booked dates",
                color: const Color(0xFF00A86B),
                onTap: onGoToAvailability,
              ),
              _buildActionCard(
                icon: Icons.approval_rounded,
                title: "Bookings",
                subtitle: "Booking approvals",
                color: const Color(0xFFFF9800),
                onTap: onGoToBookChat,
              ),
              _buildActionCard(
                icon: Icons.chat_bubble_outline_rounded,
                title: "Chat",
                subtitle: "Reply to tenants",
                color: const Color(0xFFE53935),
                onTap: onGoToBookChat,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(
            title: "Your Listings",
            actionText: "See all",
            primaryText: primaryText,
            dark: dark,
          ),
          const SizedBox(height: 14),
          _buildFirestoreListings(landlordId),
        ],
      ),
    );
  }

  Widget _buildHeroWithCounts(String landlordId) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: PropertyService().getLandlordPropertiesStream(landlordId),
      builder: (context, propertySnapshot) {
        final propertyDocs = propertySnapshot.data?.docs ?? [];
        final listingsCount = propertyDocs.length;

        final bookedCount = propertyDocs.where((doc) {
          final data = doc.data();
          return data['isAvailable'] == false;
        }).length;

        return _HeroCard(
          userName: userName,
          dark: dark,
          glassBorder: glassBorder,
          accentBlue: accentBlue,
          listingsCount: listingsCount,
          bookedCount: bookedCount,
        );
      },
    );
  }

  Widget _buildInsightBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: glassCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: glassBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFE6BC6D).withOpacity(0.18),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: Color(0xFFC69545),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tip: Keep availability updated so tenants can book faster.',
              style: GoogleFonts.inter(
                fontSize: 12.8,
                height: 1.45,
                color: secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewContainer(String landlordId) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: PropertyService().getLandlordPropertiesStream(landlordId),
      builder: (context, propertySnapshot) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: BookingService().getLandlordBookings(landlordId),
          builder: (context, bookingSnapshot) {
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: ChatService().getLandlordChats(landlordId),
              builder: (context, chatSnapshot) {
                final propertyDocs = propertySnapshot.data?.docs ?? [];
                final bookingDocs = bookingSnapshot.data?.docs ?? [];
                final chatDocs = chatSnapshot.data?.docs ?? [];

                final pendingCount = bookingDocs.where((doc) {
                  final status = (doc.data()['status'] ?? '').toString();
                  return status.toLowerCase() == 'pending';
                }).length;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: dark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.52),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: dark
                          ? Colors.white.withOpacity(0.10)
                          : const Color(0xFFD6BC91).withOpacity(0.8),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: dark
                            ? Colors.black.withOpacity(0.18)
                            : const Color(0xFFD8AF5B).withOpacity(0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(
                        title: "Overview",
                        primaryText: primaryText,
                        dark: dark,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Dashboard summary",
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
                            child: _SummaryCard(
                              title: "Properties",
                              value: propertyDocs.length.toString(),
                              icon: Icons.home_work_rounded,
                              color: accentBlue,
                              dark: dark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SummaryCard(
                              title: "Bookings",
                              value: bookingDocs.length.toString(),
                              icon: Icons.book_online_rounded,
                              color: const Color(0xFF00A86B),
                              dark: dark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryCard(
                              title: "Pending",
                              value: pendingCount.toString(),
                              icon: Icons.hourglass_top_rounded,
                              color: const Color(0xFFFF9800),
                              dark: dark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SummaryCard(
                              title: "Chats",
                              value: chatDocs.length.toString(),
                              icon: Icons.chat_bubble_outline_rounded,
                              color: const Color(0xFFE53935),
                              dark: dark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFirestoreListings(String landlordId) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: PropertyService().getLandlordPropertiesStream(landlordId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: glassCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: glassBorder),
            ),
            child: Text(
              'No listings yet. Add your first property.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return Column(
          children: docs.take(5).map((doc) {
            final property = doc.data();

            final bool isAvailable = property['isAvailable'] ?? true;

            return _propertyItem(
              title: property['title'] ?? 'Property',
              price: property['price'] ?? '',
              location: property['location'] ?? '',
              status: isAvailable ? 'Available' : 'Booked',
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required Color primaryText,
    required bool dark,
    String? actionText,
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
              color: dark ? const Color(0xFFE6BC6D) : const Color(0xFFC9A24A),
            ),
          ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: glassCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withOpacity(0.24), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: dark
                    ? Colors.black.withOpacity(0.20)
                    : color.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: color.withOpacity(0.14),
                    child: Icon(icon, color: color, size: 25),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: dark ? Colors.white70 : color,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: dark ? Colors.white : const Color(0xFF1D1D1F),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12.2,
                  height: 1.4,
                  color: dark ? Colors.white70 : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _propertyItem({
    required String title,
    required String price,
    required String location,
    required String status,
  }) {
    Color statusColor;
    Color statusBg;

    switch (status.toLowerCase()) {
      case "available":
        statusColor = Colors.green;
        statusBg = Colors.green.withOpacity(0.12);
        break;
      case "booked":
        statusColor = Colors.orange;
        statusBg = Colors.orange.withOpacity(0.12);
        break;
      default:
        statusColor = Colors.redAccent;
        statusBg = Colors.redAccent.withOpacity(0.12);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: dark
                  ? Colors.white.withOpacity(0.06)
                  : const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.home_work_rounded,
              color: Color(0xFF355CDE),
              size: 28,
            ),
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
                    fontSize: 14.5,
                    color: dark ? Colors.white : const Color(0xFF1D1D1F),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: dark ? Colors.white60 : const Color(0xFFB39B78),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: GoogleFonts.inter(
                          color: dark ? Colors.white70 : Colors.grey.shade700,
                          fontSize: 12.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: dark
                        ? const Color(0xFFE6BC6D)
                        : const Color(0xFFC9A24A),
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: statusBg,
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
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String userName;
  final bool dark;
  final Color glassBorder;
  final Color accentBlue;
  final int listingsCount;
  final int bookedCount;

  const _HeroCard({
    required this.userName,
    required this.dark,
    required this.glassBorder,
    required this.accentBlue,
    required this.listingsCount,
    required this.bookedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: glassBorder),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.22)
                : const Color(0xFFB88C45).withOpacity(0.14),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('images/kl3.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dark
                ? [
                    Colors.black.withOpacity(0.45),
                    const Color(0xFF0F172A).withOpacity(0.72),
                  ]
                : [
                    const Color(0xFF2B2118).withOpacity(0.28),
                    const Color(0xFF5C4630).withOpacity(0.52),
                  ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(dark ? 0.10 : 0.18),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.18)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      size: 18,
                      color: Color(0xFFE6BC6D),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Landlord',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 38),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Welcome back,\n',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.05,
                    ),
                  ),
                  TextSpan(
                    text: '$userName !',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE6BC6D),
                      height: 1.05,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Manage your listings, availability, tenant chats and booking approvals in one place.',
              style: GoogleFonts.inter(
                fontSize: 13.5,
                height: 1.6,
                color: Colors.white.withOpacity(0.90),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _heroMiniChip(
                    icon: Icons.home_work_outlined,
                    label: '$listingsCount listings',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _heroMiniChip(
                    icon: Icons.calendar_month_outlined,
                    label: '$bookedCount booked',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFE6BC6D).withOpacity(0.25),
                    const Color(0xFFC9A24A).withOpacity(0.18),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFFE6BC6D).withOpacity(0.40),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: accentBlue.withOpacity(0.22),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your dashboard is now connected to Firestore.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroMiniChip({required IconData icon, required String label}) {
    final parts = label.split(' ');
    final number = parts.isNotEmpty ? parts.first : label;
    final text = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFE6BC6D)),
          const SizedBox(width: 8),
          Text(
            number,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          if (text.isNotEmpty) ...[
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.92),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool dark;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
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
            backgroundColor: color.withOpacity(0.10),
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
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: dark ? Colors.white : const Color(0xFF1D1D1F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: dark ? Colors.white70 : Colors.grey.shade700,
                    fontSize: 12.8,
                    fontWeight: FontWeight.w500,
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
