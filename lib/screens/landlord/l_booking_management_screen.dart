import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/services/booking_service.dart';

class LandlordBookingManagementScreen extends StatelessWidget {
  const LandlordBookingManagementScreen({super.key});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'confirmed':
      case 'successful':
        return Colors.green;
      case 'rejected':
      case 'unsuccessful':
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.orange;
    }
  }

  void _viewReceipt(BuildContext context, String receiptUrl, bool dark) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: dark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Payment Receipt',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: dark ? Colors.white : const Color(0xFF2C2621),
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    receiptUrl,
                    fit: BoxFit.contain,
                    height: 360,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 220,
                        alignment: Alignment.center,
                        child: Text(
                          'Unable to load receipt image',
                          style: GoogleFonts.inter(
                            color: dark
                                ? Colors.white70
                                : const Color(0xFF7B664C),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB17B30),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showRejectReasonDialog(
    BuildContext context,
    String bookingId,
  ) async {
    final TextEditingController reasonController = TextEditingController();

    final String? reason = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reject Booking'),
          content: TextField(
            controller: reasonController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter rejection reason',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, reasonController.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );

    reasonController.dispose();

    if (reason == null || reason.isEmpty) return;

    await BookingService().rejectBooking(bookingId, rejectionReason: reason);

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Booking rejected')));
  }

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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: BookingService().getAllBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load bookings.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(
                'No bookings yet',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final bookingId = docs[index].id;
              final booking = docs[index].data();

              final String status = (booking['status'] ?? 'Pending').toString();
              final String receiptUrl = (booking['receiptPath'] ?? '')
                  .toString();
              final String rejectionReason = (booking['rejectionReason'] ?? '')
                  .toString();

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: dark
                        ? Colors.white.withOpacity(0.08)
                        : const Color(0xFFD6B36A).withOpacity(0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['propertyTitle'] ?? 'Property Booking',
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
                    const SizedBox(height: 4),
                    Text(
                      'Guests: ${booking['guests'] ?? 1}',
                      style: GoogleFonts.inter(
                        fontSize: 12.8,
                        color: secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Payment: ${booking['paymentMethod'] ?? '-'}',
                      style: GoogleFonts.inter(
                        fontSize: 12.8,
                        color: secondaryText,
                      ),
                    ),

                    if (status.toLowerCase() == 'rejected' &&
                        rejectionReason.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Reason: $rejectionReason',
                        style: GoogleFonts.inter(
                          fontSize: 12.8,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    if (receiptUrl.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          receiptUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: dark
                                    ? Colors.white.withOpacity(0.05)
                                    : const Color(0xFFF3E8D7),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Receipt preview unavailable',
                                style: GoogleFonts.inter(
                                  color: secondaryText,
                                  fontSize: 12.5,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _viewReceipt(context, receiptUrl, dark),
                          icon: const Icon(Icons.receipt_long_rounded),
                          label: const Text('View Receipt'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFB17B30),
                            side: const BorderSide(color: Color(0xFFB17B30)),
                          ),
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: dark
                              ? Colors.white.withOpacity(0.05)
                              : const Color(0xFFF3E8D7),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'No receipt uploaded',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: secondaryText,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    _statusBadge(status),

                    if (status.toLowerCase() == 'pending') ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await BookingService().approveBooking(
                                  bookingId,
                                );

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Booking approved'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Approve',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showRejectReasonDialog(context, bookingId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Reject',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _statusBadge(String status) {
    final Color color = _statusColor(status);

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
