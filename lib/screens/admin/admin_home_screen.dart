import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admin_dashboard_tab.dart';
import 'admin_users_tab.dart';
import 'admin_reports_tab.dart';
import 'admin_settings_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const AdminHomeScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _tabs = [
    const AdminDashboardTab(),
    const AdminUsersTab(),
    const AdminReportsTab(),
    AdminSettingsScreen(
      userName: widget.userName,
      userEmail: widget.userEmail,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          bottom: false,
          child: IndexedStack(index: _currentIndex, children: _tabs),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF1A1A1A) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(dark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFD6B36A),
          unselectedItemColor: dark ? Colors.white54 : const Color(0xFF9B8A72),
          selectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded),
              activeIcon: Icon(Icons.people_rounded),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report_gmailerrorred_outlined),
              activeIcon: Icon(Icons.report_rounded),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
