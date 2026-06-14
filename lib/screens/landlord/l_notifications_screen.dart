import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/services/notification_service.dart';

class LandlordNotificationsScreen extends StatelessWidget {
  const LandlordNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color screenBg = Theme.of(context).scaffoldBackgroundColor;
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);
    final Color cardBg = dark
        ? const Color(0xFF1E293B).withOpacity(0.92)
        : Colors.white.withOpacity(0.88);

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        backgroundColor: screenBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        iconTheme: IconThemeData(color: primaryText),
      ),
      body: user == null
          ? Center(
              child: Text(
                'Please login first.',
                style: GoogleFonts.inter(color: secondaryText),
              ),
            )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: NotificationService().getUserNotifications(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load notifications.',
                      style: GoogleFonts.inter(color: secondaryText),
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No notifications yet.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final item = doc.data();

                    final bool isRead = item['isRead'] == true;

                    return GestureDetector(
                      onTap: () {
                        NotificationService().markAsRead(doc.id);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isRead
                                ? Colors.transparent
                                : const Color(0xFFB17B30).withOpacity(0.55),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFD6B36A,
                                ).withOpacity(0.18),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                isRead
                                    ? Icons.notifications_none_rounded
                                    : Icons.notifications_active_rounded,
                                color: const Color(0xFFB17B30),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item['message'] ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.8,
                                      color: secondaryText,
                                      height: 1.45,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    isRead ? 'Read' : 'Unread',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: isRead
                                          ? secondaryText
                                          : const Color(0xFFB17B30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
