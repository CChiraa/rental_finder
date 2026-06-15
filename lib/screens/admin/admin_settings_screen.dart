import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/main.dart';
import 'package:smart_rental_app/screens/welcome_screen.dart';
import 'package:smart_rental_app/services/auth_service.dart';

class AdminSettingsScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const AdminSettingsScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = MyApp.of(context)?.currentThemeMode ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg =
        dark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.82);
    final Color border =
        dark ? Colors.white.withOpacity(0.14) : Colors.white.withOpacity(0.90);
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        Text(
          'Settings',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        const SizedBox(height: 18),

        // Admin profile card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFB17B30).withOpacity(0.18),
                child: const Icon(Icons.shield_rounded,
                    color: Color(0xFFB17B30), size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.userEmail,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB17B30).withOpacity(0.14),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Administrator',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFB17B30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _sectionTitle('Preferences', primaryText),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
          ),
          child: SwitchListTile(
            value: isDarkMode,
            onChanged: (value) {
              setState(() => isDarkMode = value);
              MyApp.of(context)?.setDarkMode(value);
            },
            activeColor: const Color(0xFFD6B36A),
            title: Text(
              'Dark Mode',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            subtitle: Text(
              'Switch between light and dark theme',
              style: GoogleFonts.inter(fontSize: 12.5, color: secondaryText),
            ),
            secondary: Icon(
              isDarkMode
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              color: const Color(0xFFB17B30),
            ),
          ),
        ),
        const SizedBox(height: 20),

        _sectionTitle('About', primaryText),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              _infoTile('App', 'YuppiesLah', primaryText, secondaryText),
              Divider(color: border, height: 1),
              _infoTile('Role', 'Admin Panel', primaryText, secondaryText),
              Divider(color: border, height: 1),
              _infoTile('Version', '1.0.0', primaryText, secondaryText),
            ],
          ),
        ),
        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout_rounded),
            label: Text(
              'Logout',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }

  Widget _infoTile(
    String label,
    String value,
    Color primaryText,
    Color secondaryText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13.5, color: secondaryText),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
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
          style:
              GoogleFonts.inter(fontWeight: FontWeight.w700, color: primaryText),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.inter(color: secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: secondaryText)),
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
}
