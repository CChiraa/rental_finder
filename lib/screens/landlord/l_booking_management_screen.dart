import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandlordBookingManagementScreen extends StatelessWidget {
  final List<Map<String, dynamic>> bookings;

  const LandlordBookingManagementScreen({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
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
          'Booking Management',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        iconTheme: IconThemeData(color: primaryText),
      ),
      body: bookings.isEmpty
          ? Center(
              child: Text(
                'No bookings yet',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final status =
                    (booking['bookingStatus'] ?? booking['status'] ?? 'Pending')
                        .toString();

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['title'] ?? 'Property Booking',
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tenant: ${booking['tenantName'] ?? 'Unknown Tenant'}',
                        style: GoogleFonts.inter(
                          fontSize: 12.8,
                          color: secondaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Check-in: ${booking['checkIn'] ?? '-'}',
                        style: GoogleFonts.inter(
                          fontSize: 12.8,
                          color: secondaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Check-out: ${booking['checkOut'] ?? '-'}',
                        style: GoogleFonts.inter(
                          fontSize: 12.8,
                          color: secondaryText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _statusBadge(status),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case 'approved':
      case 'confirmed':
      case 'successful':
        color = Colors.green;
        break;
      case 'rejected':
      case 'unsuccessful':
        color = Colors.redAccent;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
