import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/services/booking_service.dart';

class TenantBookingHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> bookingHistory;

  const TenantBookingHistoryScreen({super.key, required this.bookingHistory});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'successful':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
      body: user == null
          ? const Center(child: Text('Please login first.'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: BookingService().getTenantBookings(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load bookings.'));
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No bookings yet.',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7B664C),
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final booking = docs[index].data();
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
                            booking['propertyTitle'] ?? '',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: const Color(0xFF2C2621),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check-in: ${booking['checkIn'] ?? '-'}',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: const Color(0xFF7B664C),
                            ),
                          ),
                          Text(
                            'Check-out: ${booking['checkOut'] ?? '-'}',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: const Color(0xFF7B664C),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Guests: ${booking['guests'] ?? 1}',
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
                );
              },
            ),
    );
  }
}
