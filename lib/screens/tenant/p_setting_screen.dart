import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantSettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final bool bookingNotifications;
  final bool chatNotifications;
  final bool promotionalNotifications;

  const TenantSettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.bookingNotifications,
    required this.chatNotifications,
    required this.promotionalNotifications,
  });

  @override
  State<TenantSettingsScreen> createState() => _TenantSettingsScreenState();
}

class _TenantSettingsScreenState extends State<TenantSettingsScreen> {
  late bool isDarkMode;
  late bool bookingNotifications;
  late bool chatNotifications;
  late bool promotionalNotifications;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    bookingNotifications = widget.bookingNotifications;
    chatNotifications = widget.chatNotifications;
    promotionalNotifications = widget.promotionalNotifications;
  }

  void _saveSettings() {
    Navigator.pop(context, {
      'isDarkMode': isDarkMode,
      'bookingNotifications': bookingNotifications,
      'chatNotifications': chatNotifications,
      'promotionalNotifications': promotionalNotifications,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F1E7),
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2C2621),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: Text(
              'Save',
              style: GoogleFonts.inter(
                color: const Color(0xFFB17B30),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _switchTile(
            title: 'Dark Mode',
            subtitle: 'Enable dark appearance for the app',
            value: isDarkMode,
            onChanged: (value) => setState(() => isDarkMode = value),
          ),
          _switchTile(
            title: 'Booking Notifications',
            subtitle: 'Get alerts for booking updates',
            value: bookingNotifications,
            onChanged: (value) => setState(() => bookingNotifications = value),
          ),
          _switchTile(
            title: 'Chat Notifications',
            subtitle: 'Receive notifications for new messages',
            value: chatNotifications,
            onChanged: (value) => setState(() => chatNotifications = value),
          ),
          _switchTile(
            title: 'Promotional Notifications',
            subtitle: 'Receive deals and promotion updates',
            value: promotionalNotifications,
            onChanged: (value) =>
                setState(() => promotionalNotifications = value),
          ),
        ],
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFB17B30),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2C2621),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            color: const Color(0xFF7B664C),
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }
}
