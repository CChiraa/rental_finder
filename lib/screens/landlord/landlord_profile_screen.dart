import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/main.dart';
import 'package:smart_rental_app/screens/welcome_screen.dart';

import 'l_edit_profile_screen.dart';
import 'l_my_properties_screen.dart';
import 'l_booking_management_screen.dart';
import 'l_earnings_payouts_screen.dart';
import 'l_notifications_screen.dart';
import 'l_setting_screen.dart';
import 'l_help_support_screen.dart';

class LandlordProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final List<Map<String, dynamic>> properties;
  final List<Map<String, dynamic>> bookings;
  final List<Map<String, dynamic>> payouts;

  const LandlordProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.properties,
    required this.bookings,
    required this.payouts,
  });

  @override
  State<LandlordProfileScreen> createState() => _LandlordProfileScreenState();
}

class _LandlordProfileScreenState extends State<LandlordProfileScreen> {
  late String currentName;
  late String currentEmail;
  String currentPhone = "012-3456789";
  String currentLocation = "Kuala Lumpur";
  String? profileImagePath;

  bool isDarkMode = false;
  bool bookingNotifications = true;
  bool chatNotifications = true;
  bool payoutNotifications = true;

  @override
  void initState() {
    super.initState();
    currentName = widget.userName;
    currentEmail = widget.userEmail;
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => LandlordEditProfileScreen(
          userName: currentName,
          userEmail: currentEmail,
          userPhone: currentPhone,
          userLocation: currentLocation,
          profileImagePath: profileImagePath,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        currentName = result['name'] ?? currentName;
        currentEmail = result['email'] ?? currentEmail;
        currentPhone = result['phone'] ?? currentPhone;
        currentLocation = result['location'] ?? currentLocation;
        profileImagePath = result['profileImagePath'];
      });
    }
  }

  Future<void> _openSettings() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => LandlordSettingsScreen(
          isDarkMode: isDarkMode,
          bookingNotifications: bookingNotifications,
          chatNotifications: chatNotifications,
          payoutNotifications: payoutNotifications,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        isDarkMode = result['isDarkMode'] ?? isDarkMode;
        bookingNotifications =
            result['bookingNotifications'] ?? bookingNotifications;
        chatNotifications = result['chatNotifications'] ?? chatNotifications;
        payoutNotifications =
            result['payoutNotifications'] ?? payoutNotifications;
      });

      MyApp.of(context)?.setDarkMode(isDarkMode);
    }
  }

  void _showLogoutDialog() {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color dialogBg = dark ? const Color(0xFF1E293B) : Colors.white;
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Logout?',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.inter(color: secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: secondaryText),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: Text(
              'Logout',
              style: GoogleFonts.inter(
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    final Color screenBg = Theme.of(context).scaffoldBackgroundColor;
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);
    final Color mutedText = dark ? Colors.white60 : const Color(0xFF8B7355);
    final Color cardBg = dark
        ? const Color(0xFF1E293B).withOpacity(0.88)
        : Colors.white.withOpacity(0.74);
    final Color softCardBg = dark
        ? const Color(0xFF243247).withOpacity(0.88)
        : Colors.white.withOpacity(0.72);

    final Gradient backgroundGradient = dark
        ? const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF162033), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFF8F1E7), Color(0xFFF2E6D5), Color(0xFFEAD8BE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final listingsCount = widget.properties.length;
    final bookingsCount = widget.bookings.length;
    final payoutsCount = widget.payouts.length;

    return Scaffold(
      backgroundColor: screenBg,
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(
                listingsCount: listingsCount,
                bookingsCount: bookingsCount,
                payoutsCount: payoutsCount,
                dark: dark,
                primaryText: primaryText,
                mutedText: mutedText,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  children: [
                    _buildQuickInfoCard(
                      cardBg: softCardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle("Account", color: primaryText),
                    _menuTile(
                      icon: Icons.person_outline_rounded,
                      title: "Edit Profile",
                      subtitle: "Update your personal information",
                      onTap: _openEditProfile,
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _menuTile(
                      icon: Icons.home_work_outlined,
                      title: "My Properties",
                      subtitle: "Manage your property listings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LandlordMyPropertiesScreen(
                              properties: widget.properties,
                            ),
                          ),
                        );
                      },
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _menuTile(
                      icon: Icons.book_online_outlined,
                      title: "Booking Management",
                      subtitle: "Track pending and approved bookings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LandlordBookingManagementScreen(
                              bookings: widget.bookings,
                            ),
                          ),
                        );
                      },
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _menuTile(
                      icon: Icons.account_balance_wallet_outlined,
                      title: "Earnings & Payouts",
                      subtitle: "View your income and transaction records",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LandlordEarningsPayoutsScreen(
                              payouts: widget.payouts,
                            ),
                          ),
                        );
                      },
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle("Support", color: primaryText),
                    _menuTile(
                      icon: Icons.notifications_outlined,
                      title: "Notifications",
                      subtitle: "View your landlord alerts",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LandlordNotificationsScreen(),
                          ),
                        );
                      },
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _menuTile(
                      icon: Icons.settings_outlined,
                      title: "Settings",
                      subtitle: "Theme, notifications and app preferences",
                      onTap: _openSettings,
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _menuTile(
                      icon: Icons.help_outline_rounded,
                      title: "Help & Support",
                      subtitle: "FAQs, contact and landlord guide",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LandlordHelpSupportScreen(),
                          ),
                        );
                      },
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    const SizedBox(height: 28),
                    _logoutButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({
    required int listingsCount,
    required int bookingsCount,
    required int payoutsCount,
    required bool dark,
    required Color primaryText,
    required Color mutedText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF1E293B).withOpacity(0.72)
            : Colors.white.withOpacity(0.58),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.25)
                : const Color(0xFFD6B36A).withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 102,
                height: 102,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD6B36A), width: 2),
                  color: dark
                      ? const Color(0xFF243247)
                      : Colors.white.withOpacity(0.85),
                ),
                child: ClipOval(
                  child:
                      profileImagePath != null && profileImagePath!.isNotEmpty
                      ? Image.file(File(profileImagePath!), fit: BoxFit.cover)
                      : const Icon(
                          Icons.person_rounded,
                          size: 52,
                          color: Color(0xFFB8964F),
                        ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: GestureDetector(
                  onTap: _openEditProfile,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB17B30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            currentName,
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currentEmail,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: mutedText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 15,
                color: Color(0xFFB17B30),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  currentLocation,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: mutedText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  "Listings",
                  listingsCount.toString(),
                  dark: dark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  "Bookings",
                  bookingsCount.toString(),
                  dark: dark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  "Payouts",
                  payoutsCount.toString(),
                  dark: dark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCard({
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8D7).withOpacity(0.9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.phone_rounded, color: Color(0xFFB17B30)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Information",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$currentPhone • $currentLocation",
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: secondaryText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.cormorantGaramond(
          fontSize: 23,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFD6B36A).withOpacity(0.18),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFFB8964F)),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 14.2,
            color: primaryText,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 12.3, color: secondaryText),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Color(0xFFB17B30),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFFE1C27A), Color(0xFFB8964F)],
          ),
        ),
        child: ElevatedButton(
          onPressed: _showLogoutDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Text(
            "Logout",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final bool dark;

  const _StatCard(this.title, this.count, {required this.dark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF243247).withOpacity(0.95)
            : Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: const Color(0xFFB8964F),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: dark ? Colors.white70 : const Color(0xFF7B664C),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
