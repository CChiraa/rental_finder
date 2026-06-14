import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/main.dart';
import 'package:smart_rental_app/screens/welcome_screen.dart';
import 'package:smart_rental_app/services/auth_service.dart';
import 'package:smart_rental_app/screens/landlord/landlord_home_screen.dart';

import 'p_edit_profile_screen.dart';
import 'p_report_issue_screen.dart';
import 'p_saved_properties_screen.dart';
import 'p_booking_history_screen.dart';
import 'p_payment_history_screen.dart';
import 'p_setting_screen.dart';
import 'p_help_support_screen.dart';

class TenantProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final List<Map<String, dynamic>> savedProperties;
  final List<Map<String, dynamic>> bookingHistory;
  final List<Map<String, dynamic>> payments;

  const TenantProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.savedProperties,
    required this.bookingHistory,
    required this.payments,
  });

  @override
  State<TenantProfileScreen> createState() => _TenantProfileScreenState();
}

class _TenantProfileScreenState extends State<TenantProfileScreen> {
  late String currentName;
  late String currentEmail;
  String currentPhone = "012-3456789";
  String currentLocation = "Kuala Lumpur";
  String? profileImagePath;

  bool isDarkMode = false;
  bool bookingNotifications = true;
  bool chatNotifications = true;
  bool promotionalNotifications = false;

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
        builder: (_) => EditProfileScreen(
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
        builder: (_) => TenantSettingsScreen(
          isDarkMode: isDarkMode,
          bookingNotifications: bookingNotifications,
          chatNotifications: chatNotifications,
          promotionalNotifications: promotionalNotifications,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        isDarkMode = result['isDarkMode'] ?? isDarkMode;
        bookingNotifications =
            result['bookingNotifications'] ?? bookingNotifications;
        chatNotifications = result['chatNotifications'] ?? chatNotifications;
        promotionalNotifications =
            result['promotionalNotifications'] ?? promotionalNotifications;
      });

      MyApp.of(context)?.setDarkMode(isDarkMode);
    }
  }

  Future<void> _becomeLandlord() async {
    try {
      final userData = await AuthService().getUserData();

      if (userData == null) {
        throw Exception('User data not found');
      }

      final List<dynamic> roles = userData['roles'] ?? [];
      final bool alreadyLandlord = roles.contains('Landlord');

      if (alreadyLandlord) {
        final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Text('Switch to Landlord?'),
            content: const Text(
              'You already have landlord access. Do you want to switch to Landlord mode?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Switch'),
              ),
            ],
          ),
        );

        if (confirm != true) return;

        await AuthService().switchRole('Landlord');

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => LandlordHomeScreen(
              userName: currentName,
              userEmail: currentEmail,
            ),
          ),
          (route) => false,
        );

        return;
      }

      final TextEditingController nricController = TextEditingController();

      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Become a Landlord'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter your NRIC for landlord verification.'),
              const SizedBox(height: 14),
              TextFormField(
                controller: nricController,
                keyboardType: TextInputType.number,
                maxLength: 12,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'NRIC Number',
                  hintText: '990101012345',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

      if (confirm != true) {
        return;
      }

      final String nric = nricController.text.trim();

      if (!RegExp(r'^\d{12}$').hasMatch(nric)) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('NRIC must be exactly 12 digits')),
        );
        return;
      }

      await AuthService().addLandlordRole(nric: nric);
      await AuthService().switchRole('Landlord');

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => LandlordHomeScreen(
            userName: currentName,
            userEmail: currentEmail,
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to switch role: $e')));
    }
  }

  Future<void> _showLogoutDialog() async {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color dialogBg = dark ? const Color(0xFF1E293B) : Colors.white;
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    final bool? confirm = await showDialog<bool>(
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
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: secondaryText),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
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

    if (confirm != true) return;

    await AuthService().logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
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

    final savedCount = widget.savedProperties.length;
    final bookingsCount = widget.bookingHistory.length;
    const reviewsCount = 3;

    return Scaffold(
      backgroundColor: screenBg,
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(
                savedCount: savedCount,
                bookingsCount: bookingsCount,
                reviewsCount: reviewsCount,
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
                      icon: Icons.business_center_outlined,
                      title: "Become a Landlord",
                      subtitle: "List and manage rental properties",
                      onTap: _becomeLandlord,
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _menuTile(
                      icon: Icons.favorite_border_rounded,
                      title: "Saved Properties",
                      subtitle: "Your favourite rental listings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TenantSavedPropertiesScreen(
                              savedProperties: widget.savedProperties,
                            ),
                          ),
                        );
                      },
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _menuTile(
                      icon: Icons.history_rounded,
                      title: "Booking History",
                      subtitle: "Pending and successful bookings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TenantBookingHistoryScreen(
                              bookingHistory: widget.bookingHistory,
                            ),
                          ),
                        );
                      },
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _menuTile(
                      icon: Icons.payment_outlined,
                      title: "Payments",
                      subtitle: "QR payment records and uploaded receipts",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                TenantPaymentsScreen(payments: widget.payments),
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
                      icon: Icons.settings_outlined,
                      title: "Settings",
                      subtitle: "Theme, notifications and app preferences",
                      onTap: _openSettings,
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _menuTile(
                      icon: Icons.report_gmailerrorred_rounded,
                      title: "Report Issue",
                      subtitle: "Tell us if something went wrong",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReportIssueScreen(),
                          ),
                        );
                      },
                      cardBg: cardBg,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _menuTile(
                      icon: Icons.help_outline_rounded,
                      title: "Help & Support",
                      subtitle: "FAQs, contact and user guide",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TenantHelpSupportScreen(),
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
    required int savedCount,
    required int bookingsCount,
    required int reviewsCount,
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
                child: _StatCard("Saved", savedCount.toString(), dark: dark),
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
                  "Reviews",
                  reviewsCount.toString(),
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
