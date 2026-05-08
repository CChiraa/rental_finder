import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'landlord_home_tab.dart';
import 'landlord_availability_tab.dart';
import 'landlord_add_tab.dart';
import 'landlord_book_chat_tab.dart';
import 'landlord_profile_screen.dart';

class LandlordHomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const LandlordHomeScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<LandlordHomeScreen> createState() => _LandlordHomeScreenState();
}

class _LandlordHomeScreenState extends State<LandlordHomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> landlordProperties = [
    {
      'title': 'Skyline Residence',
      'location': 'Kuala Lumpur',
      'price': 'RM 1,800 / month',
      'image': '',
    },
    {
      'title': 'Urban Loft Studio',
      'location': 'Petaling Jaya',
      'price': 'RM 1,250 / month',
      'image': '',
    },
  ];

  final List<Map<String, dynamic>> landlordBookings = [
    {
      'title': 'Skyline Residence',
      'tenantName': 'Aina',
      'checkIn': '2026-04-25',
      'checkOut': '2026-05-25',
      'bookingStatus': 'Pending',
    },
    {
      'title': 'Urban Loft Studio',
      'tenantName': 'Hakim',
      'checkIn': '2026-04-20',
      'checkOut': '2026-06-20',
      'bookingStatus': 'Confirmed',
    },
  ];

  final List<Map<String, dynamic>> landlordPayouts = [
    {
      'title': 'April Rental Payout',
      'date': '2026-04-18',
      'amount': 'RM 1,800',
    },
    {
      'title': 'March Rental Payout',
      'date': '2026-03-18',
      'amount': 'RM 1,250',
    },
  ];

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
        : Colors.white.withOpacity(0.72);

    final Color glassBorder = dark
        ? Colors.white.withOpacity(0.14)
        : Colors.white.withOpacity(0.90);

    final Color primaryText = colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B6243);

    final Color navSelectedColor = dark
        ? const Color(0xFFE6BC6D)
        : const Color(0xFFC9A24A);

    final Color navUnselectedColor = dark
        ? Colors.white54
        : const Color(0xFFB39B78);

    final Color accentBlue = dark
        ? const Color(0xFF9DB7E8)
        : const Color(0xFF355CDE);

    final List<Widget> pages = [
      LandlordHomeTab(
        userName: widget.userName,
        dark: dark,
        glassCard: glassCard,
        glassBorder: glassBorder,
        primaryText: primaryText,
        secondaryText: secondaryText,
        accentBlue: accentBlue,
        onGoToAvailability: () => setState(() => _currentIndex = 1),
        onGoToAdd: () => setState(() => _currentIndex = 2),
        onGoToBookChat: () => setState(() => _currentIndex = 3),
        onGoToProfile: () => setState(() => _currentIndex = 4),
      ),
      LandlordAvailabilityTab(
        dark: dark,
        glassCard: glassCard,
        glassBorder: glassBorder,
      ),
      LandlordAddTab(
        dark: dark,
        glassCard: glassCard,
        glassBorder: glassBorder,
      ),
      LandlordBookChatTab(
        dark: dark,
        glassCard: glassCard,
        glassBorder: glassBorder,
      ),
      LandlordProfileScreen(
        userName: widget.userName,
        userEmail: widget.userEmail,
        properties: landlordProperties,
        bookings: landlordBookings,
        payouts: landlordPayouts,
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
        selectedColor: navSelectedColor,
        unselectedColor: navUnselectedColor,
      ),
    );
  }

  Widget _buildBottomNavBar({
    required bool dark,
    required Color glassCard,
    required Color glassBorder,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: dark ? glassCard : const Color(0xFFF8F3EC).withOpacity(0.96),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: dark ? glassBorder : const Color(0xFFF1E7D8)),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.26)
                : Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          iconSize: 22,
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
              icon: Icon(Icons.calendar_today_rounded),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
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
