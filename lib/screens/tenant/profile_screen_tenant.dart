import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/welcome_screen.dart';
import 'edit_profile_screen.dart';
import 'report_issue_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String currentName;
  late String currentEmail;
  String currentPhone = "012-3456789";
  String currentLocation = "Kuala Lumpur";

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
        ),
      ),
    );

    if (result != null) {
      setState(() {
        currentName = result['name'] ?? currentName;
        currentEmail = result['email'] ?? currentEmail;
        currentPhone = result['phone'] ?? currentPhone;
        currentLocation = result['location'] ?? currentLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F1E7), Color(0xFFF2E6D5), Color(0xFFEAD8BE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _header(),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _sectionTitle("Account"),

                    _menuTile(
                      Icons.person_outline,
                      "Edit Profile",
                      "Update your personal information",
                      _openEditProfile,
                    ),
                    _menuTile(
                      Icons.favorite_border,
                      "Saved Properties",
                      "Your favorite listings",
                      () {},
                    ),
                    _menuTile(
                      Icons.history,
                      "Booking History",
                      "Your past bookings",
                      () {},
                    ),
                    _menuTile(
                      Icons.payment_outlined,
                      "Payments",
                      "Manage payments",
                      () {},
                    ),

                    const SizedBox(height: 20),

                    _sectionTitle("Support"),

                    _menuTile(
                      Icons.settings_outlined,
                      "Settings",
                      "App preferences",
                      () {},
                    ),
                    _menuTile(
                      Icons.report_outlined,
                      "Report Issue",
                      "Report serious problems",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReportIssueScreen(),
                          ),
                        );
                      },
                    ),
                    _menuTile(
                      Icons.help_outline,
                      "Help & Support",
                      "Get assistance",
                      () {},
                    ),

                    const SizedBox(height: 30),

                    _logoutButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 💎 HEADER
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD6B36A).withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFFD6B36A), width: 2),
            ),
            child: const Icon(Icons.person, size: 50, color: Color(0xFFB8964F)),
          ),

          const SizedBox(height: 14),

          // Name
          Text(
            currentName,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C2621),
            ),
          ),

          const SizedBox(height: 6),

          // Email
          Text(currentEmail, style: const TextStyle(color: Color(0xFF8B7355))),

          const SizedBox(height: 4),

          // Location
          Text(
            currentLocation,
            style: const TextStyle(color: Color(0xFF8B7355), fontSize: 13),
          ),

          const SizedBox(height: 20),

          Row(
            children: const [
              Expanded(child: _StatCard("Saved", "12")),
              SizedBox(width: 10),
              Expanded(child: _StatCard("Bookings", "5")),
              SizedBox(width: 10),
              Expanded(child: _StatCard("Reviews", "3")),
            ],
          ),
        ],
      ),
    );
  }

  // 💎 TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.cormorantGaramond(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2C2621),
        ),
      ),
    );
  }

  // 💎 MENU TILE
  Widget _menuTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFD6B36A).withOpacity(0.2),
          child: Icon(icon, color: const Color(0xFFB8964F)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // 💎 LOGOUT
  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFE1C27A), Color(0xFFB8964F)],
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: const Text("Logout", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

// 💎 STAT CARD
class _StatCard extends StatelessWidget {
  final String title;
  final String count;

  const _StatCard(this.title, this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFB8964F),
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
