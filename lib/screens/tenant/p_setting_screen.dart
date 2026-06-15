import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantSettingsScreen extends StatefulWidget {
  final bool bookingNotifications;
  final bool chatNotifications;
  final bool promotionalNotifications;

  const TenantSettingsScreen({
    super.key,

    required this.bookingNotifications,
    required this.chatNotifications,
    required this.promotionalNotifications,
  });

  @override
  State<TenantSettingsScreen> createState() => _TenantSettingsScreenState();
}

class _TenantSettingsScreenState extends State<TenantSettingsScreen> {
  late bool bookingNotifications;
  late bool chatNotifications;
  late bool promotionalNotifications;

  @override
  void initState() {
    super.initState();
    bookingNotifications = widget.bookingNotifications;
    chatNotifications = widget.chatNotifications;
    promotionalNotifications = widget.promotionalNotifications;
  }

  void _saveSettings() {
    Navigator.pop(context, {
      'bookingNotifications': bookingNotifications,
      'chatNotifications': chatNotifications,
      'promotionalNotifications': promotionalNotifications,
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color screenBg = Theme.of(context).scaffoldBackgroundColor;
    final Color cardBg = dark
        ? const Color(0xFF1E293B).withOpacity(0.92)
        : Colors.white.withOpacity(0.9);
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        backgroundColor: screenBg,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryText,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: dark
              ? const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFF8F1E7),
                    Color(0xFFF2E6D5),
                    Color(0xFFEAD8BE),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _switchTile(
              title: 'Booking Notifications',
              subtitle: 'Get alerts for booking updates',
              value: bookingNotifications,
              onChanged: (value) =>
                  setState(() => bookingNotifications = value),
              cardBg: cardBg,
              primaryText: primaryText,
              secondaryText: secondaryText,
            ),
            _switchTile(
              title: 'Chat Notifications',
              subtitle: 'Receive notifications for new messages',
              value: chatNotifications,
              onChanged: (value) => setState(() => chatNotifications = value),
              cardBg: cardBg,
              primaryText: primaryText,
              secondaryText: secondaryText,
            ),
            _switchTile(
              title: 'Promotional Notifications',
              subtitle: 'Receive deals and promotion updates',
              value: promotionalNotifications,
              onChanged: (value) =>
                  setState(() => promotionalNotifications = value),
              cardBg: cardBg,
              primaryText: primaryText,
              secondaryText: secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cardBg,
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
            color: primaryText,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(color: secondaryText, fontSize: 12.5),
        ),
      ),
    );
  }
}
