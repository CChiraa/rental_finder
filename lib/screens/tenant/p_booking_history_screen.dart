import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantBookingHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> bookingHistory;

  const TenantBookingHistoryScreen({super.key, required this.bookingHistory});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'successful':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F1E7),
        elevation: 0,
        title: Text(
          'Booking History',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2C2621),
          ),
        ),
      ),
      body: bookingHistory.isEmpty
          ? Center(
              child: Text(
                'No bookings yet.',
                style: GoogleFonts.inter(
                  color: const Color(0xFF7B664C),
                  fontSize: 14,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: bookingHistory.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = bookingHistory[index];
                final status = booking['status'] ?? 'Pending';

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['title'] ?? '',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF2C2621),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        booking['location'] ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: const Color(0xFF7B664C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            booking['date'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: const Color(0xFF7B664C),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(status).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _statusColor(status),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
