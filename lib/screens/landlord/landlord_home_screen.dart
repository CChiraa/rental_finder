import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// IMPORT YOUR EXISTING SCREENS
import 'add_property_screen_landlord.dart';
import 'profile_screen_landlord.dart';

class LandlordHomeScreen extends StatefulWidget {
  final String userName;

  const LandlordHomeScreen({super.key, required this.userName});

  @override
  State<LandlordHomeScreen> createState() => _LandlordHomeScreenState();
}

class _LandlordHomeScreenState extends State<LandlordHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Gradient backgroundGradient = dark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF111827),
              Color(0xFF172554),
              Color(0xFF0F172A),
            ],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F1E7),
              Color(0xFFF2E6D5),
              Color(0xFFEAD8BE),
              Color(0xFFF7EFE5),
            ],
          );

    final Color glassCard = dark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.58);

    final Color glassBorder = dark
        ? Colors.white.withOpacity(0.14)
        : Colors.white.withOpacity(0.72);

    final Color primaryText = colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B6243);
    final Color accentBlue = dark
        ? const Color(0xFF9DB7E8)
        : const Color(0xFF355CDE);

    final List<Widget> pages = [
      _buildHomeTab(
        dark: dark,
        glassCard: glassCard,
        glassBorder: glassBorder,
        primaryText: primaryText,
        secondaryText: secondaryText,
        accentBlue: accentBlue,
      ),
      _AvailabilityTab(
        dark: dark,
        glassCard: glassCard,
        glassBorder: glassBorder,
      ),
      const AddPropertyScreen(),
      _BookChatTab(dark: dark, glassCard: glassCard, glassBorder: glassBorder),
      LandlordProfileScreen(
        userName: widget.userName,
        userEmail: 'landlord@email.com',
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: Stack(
          children: [
            _buildBackgroundGlowTopRight(dark),
            _buildBackgroundGlowBottomLeft(dark),
            SafeArea(child: pages[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(
        dark: dark,
        glassCard: glassCard,
        glassBorder: glassBorder,
        accentBlue: accentBlue,
      ),
    );
  }

  Widget _buildHomeTab({
    required bool dark,
    required Color glassCard,
    required Color glassBorder,
    required Color primaryText,
    required Color secondaryText,
    required Color accentBlue,
  }) {
    final Color titleStart = dark ? Colors.white : const Color(0xFF2B2118);
    final Color titleMid = dark
        ? const Color(0xFF9DB7E8)
        : const Color(0xFF8E6A39);
    final Color titleEnd = dark
        ? const Color(0xFFE6BC6D)
        : const Color(0xFFD8AF5B);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroCard(
            dark: dark,
            glassCard: glassCard,
            glassBorder: glassBorder,
            secondaryText: secondaryText,
            titleStart: titleStart,
            titleMid: titleMid,
            titleEnd: titleEnd,
            accentBlue: accentBlue,
          ),
          const SizedBox(height: 18),
          _buildInsightBanner(
            dark: dark,
            glassCard: glassCard,
            glassBorder: glassBorder,
            secondaryText: secondaryText,
          ),
          const SizedBox(height: 22),

          _buildSectionTitle(
            title: "Overview",
            actionText: "This month",
            primaryText: primaryText,
            secondaryText: secondaryText,
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
                  value: "12",
                  icon: Icons.home_work_rounded,
                  color: accentBlue,
                  dark: dark,
                  glassCard: glassCard,
                  glassBorder: glassBorder,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: "Bookings",
                  value: "8",
                  icon: Icons.book_online_rounded,
                  color: const Color(0xFF00A86B),
                  dark: dark,
                  glassCard: glassCard,
                  glassBorder: glassBorder,
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
                  value: "4",
                  icon: Icons.hourglass_top_rounded,
                  color: const Color(0xFFFF9800),
                  dark: dark,
                  glassCard: glassCard,
                  glassBorder: glassBorder,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: "Chats",
                  value: "6",
                  icon: Icons.chat_bubble_outline_rounded,
                  color: const Color(0xFFE53935),
                  dark: dark,
                  glassCard: glassCard,
                  glassBorder: glassBorder,
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          _buildSectionTitle(
            title: "Quick Actions",
            actionText: "Manage",
            primaryText: primaryText,
            secondaryText: const Color(0xFF355CDE),
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
                dark: dark,
                glassCard: glassCard,
                glassBorder: glassBorder,
                icon: Icons.add_business_rounded,
                title: "Add Property",
                subtitle: "Create a new listing",
                color: accentBlue,
                onTap: () {
                  setState(() => _currentIndex = 2);
                },
              ),
              _buildActionCard(
                dark: dark,
                glassCard: glassCard,
                glassBorder: glassBorder,
                icon: Icons.calendar_month_rounded,
                title: "Availability",
                subtitle: "View booked dates",
                color: const Color(0xFF00A86B),
                onTap: () {
                  setState(() => _currentIndex = 1);
                },
              ),
              _buildActionCard(
                dark: dark,
                glassCard: glassCard,
                glassBorder: glassBorder,
                icon: Icons.approval_rounded,
                title: "Bookings",
                subtitle: "Booking & payments",
                color: const Color(0xFFFF9800),
                onTap: () {
                  setState(() => _currentIndex = 3);
                },
              ),
              _buildActionCard(
                dark: dark,
                glassCard: glassCard,
                glassBorder: glassBorder,
                icon: Icons.person_outline_rounded,
                title: "Profile",
                subtitle: "Manage account",
                color: const Color(0xFFE53935),
                onTap: () {
                  setState(() => _currentIndex = 4);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionTitle(
            title: "Your Listings",
            actionText: "See all",
            primaryText: primaryText,
            secondaryText: accentBlue,
          ),
          const SizedBox(height: 14),
          _propertyItem(
            dark: dark,
            glassCard: glassCard,
            glassBorder: glassBorder,
            title: "Condo near KLCC",
            price: "RM178 / night",
            location: "Kuala Lumpur",
            status: "Available",
          ),
          _propertyItem(
            dark: dark,
            glassCard: glassCard,
            glassBorder: glassBorder,
            title: "Studio Apartment",
            price: "RM120 / night",
            location: "Petaling Jaya",
            status: "Booked",
          ),
          _propertyItem(
            dark: dark,
            glassCard: glassCard,
            glassBorder: glassBorder,
            title: "Cozy Family House",
            price: "RM250 / night",
            location: "Shah Alam",
            status: "Pending",
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard({
    required bool dark,
    required Color glassCard,
    required Color glassBorder,
    required Color secondaryText,
    required Color titleStart,
    required Color titleMid,
    required Color titleEnd,
    required Color accentBlue,
  }) {
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
            const SizedBox(height: 26),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [titleStart, titleMid, titleEnd],
              ).createShader(bounds),
              child: Text(
                'Welcome back,\n${widget.userName} ✨',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.05,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Manage your listings, availability, tenant chats and booking approvals in one place.',
              style: GoogleFonts.inter(
                fontSize: 13.5,
                height: 1.6,
                color: Colors.white.withOpacity(0.88),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _heroMiniChip(
                  icon: Icons.home_work_outlined,
                  label: '12 listings',
                  dark: true,
                ),
                const SizedBox(width: 10),
                _heroMiniChip(
                  icon: Icons.calendar_month_outlined,
                  label: '5 booked dates',
                  dark: true,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white.withOpacity(0.10),
                border: Border.all(color: Colors.white.withOpacity(0.14)),
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
                      'Your property engagement is improving this week.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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

  Widget _heroMiniChip({
    required IconData icon,
    required String label,
    required bool dark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withOpacity(0.10)
            : Colors.white.withOpacity(0.60),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFE6BC6D)),
          const SizedBox(width: 7),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightBanner({
    required bool dark,
    required Color glassCard,
    required Color glassBorder,
    required Color secondaryText,
  }) {
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

  Widget _buildSectionTitle({
    required String title,
    required String actionText,
    required Color primaryText,
    required Color secondaryText,
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
        Text(
          actionText,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required bool dark,
    required Color glassCard,
    required Color glassBorder,
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
            border: Border.all(color: color.withOpacity(0.28), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: dark
                    ? Colors.black.withOpacity(0.20)
                    : color.withOpacity(0.10),
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
    required bool dark,
    required Color glassCard,
    required Color glassBorder,
    required String title,
    required String price,
    required String location,
    required String status,
  }) {
    Color statusColor;
    Color statusBg;

    switch (status) {
      case "Available":
        statusColor = Colors.green;
        statusBg = Colors.green.withOpacity(0.12);
        break;
      case "Booked":
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
                Text(
                  location,
                  style: GoogleFonts.inter(
                    color: dark ? Colors.white70 : Colors.grey.shade700,
                    fontSize: 12.8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: dark
                        ? const Color(0xFFE6BC6D)
                        : const Color(0xFF0F2891),
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

  Widget _buildBottomNavBar({
    required bool dark,
    required Color glassCard,
    required Color glassBorder,
    required Color accentBlue,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: glassCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: glassBorder),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.26)
                : Colors.black.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: accentBlue,
          unselectedItemColor: dark ? Colors.white54 : Colors.grey,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum_rounded),
              label: 'Book & Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGlowTopRight(bool dark) {
    return Positioned(
      top: -90,
      right: -60,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dark
              ? const Color(0xFF1D4ED8).withOpacity(0.18)
              : const Color(0xFFFFE9BF).withOpacity(0.65),
          boxShadow: [
            BoxShadow(
              color: dark
                  ? const Color(0xFF1D4ED8).withOpacity(0.18)
                  : const Color(0xFFFFE9BF).withOpacity(0.55),
              blurRadius: 100,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGlowBottomLeft(bool dark) {
    return Positioned(
      bottom: -120,
      left: -100,
      child: Container(
        width: 280,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(140),
          color: dark
              ? const Color(0xFF60A5FA).withOpacity(0.10)
              : const Color(0xFFFFE7BA).withOpacity(0.35),
          boxShadow: [
            BoxShadow(
              color: dark
                  ? const Color(0xFF60A5FA).withOpacity(0.10)
                  : const Color(0xFFFFE7BA).withOpacity(0.30),
              blurRadius: 100,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityTab extends StatelessWidget {
  final bool dark;
  final Color glassCard;
  final Color glassBorder;

  const _AvailabilityTab({
    required this.dark,
    required this.glassCard,
    required this.glassBorder,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B6243);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Place Availability",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "View available and booked dates for your properties.",
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: glassCard,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: glassBorder),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 64,
                  color: Color(0xFF355CDE),
                ),
                const SizedBox(height: 12),
                Text(
                  "Calendar View",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "You can later connect this tab with a real calendar package to show booked and available dates.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.5,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _simpleStatusCard(
            title: "Condo near KLCC",
            subtitle: "Booked: 12, 13, 14 May",
            dark: dark,
            glassCard: glassCard,
            glassBorder: glassBorder,
          ),
          _simpleStatusCard(
            title: "Studio Apartment",
            subtitle: "Available all week",
            dark: dark,
            glassCard: glassCard,
            glassBorder: glassBorder,
          ),
        ],
      ),
    );
  }
}

class _BookChatTab extends StatelessWidget {
  final bool dark;
  final Color glassCard;
  final Color glassBorder;

  const _BookChatTab({
    required this.dark,
    required this.glassCard,
    required this.glassBorder,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B6243);

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
            "Approve bookings, review payment requests and reply to tenants.",
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          _bookChatCard(
            title: "Booking Request",
            subtitle: "Aina wants to book Condo near KLCC",
            status: "Pending Approval",
            icon: Icons.approval_rounded,
            dark: dark,
            glassCard: glassCard,
            glassBorder: glassBorder,
          ),
          _bookChatCard(
            title: "Payment Request",
            subtitle: "Receipt uploaded for Studio Apartment",
            status: "Review Payment",
            icon: Icons.receipt_long_rounded,
            dark: dark,
            glassCard: glassCard,
            glassBorder: glassBorder,
          ),
          _bookChatCard(
            title: "Tenant Chat",
            subtitle: "New message from Daniel",
            status: "Open Chat",
            icon: Icons.chat_bubble_outline_rounded,
            dark: dark,
            glassCard: glassCard,
            glassBorder: glassBorder,
          ),
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
  final Color glassCard;
  final Color glassBorder;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.dark,
    required this.glassCard,
    required this.glassBorder,
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

Widget _simpleStatusCard({
  required String title,
  required String subtitle,
  required bool dark,
  required Color glassCard,
  required Color glassBorder,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: glassCard,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: glassBorder),
    ),
    child: Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF355CDE).withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.home_work_rounded, color: Color(0xFF355CDE)),
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
              Text(
                subtitle,
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

Widget _bookChatCard({
  required String title,
  required String subtitle,
  required String status,
  required IconData icon,
  required bool dark,
  required Color glassCard,
  required Color glassBorder,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: glassCard,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: glassBorder),
    ),
    child: Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFE6BC6D).withOpacity(0.16),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: const Color(0xFFC69545)),
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
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: dark ? Colors.white70 : Colors.grey.shade700,
                  fontSize: 12.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                status,
                style: GoogleFonts.inter(
                  color: const Color(0xFF355CDE),
                  fontSize: 12.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
