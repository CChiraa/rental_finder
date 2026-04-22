import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BcBookingScreen extends StatelessWidget {
  final bool dark;
  final Color glassCard;
  final Color glassBorder;

  const BcBookingScreen({
    super.key,
    required this.dark,
    required this.glassCard,
    required this.glassBorder,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B6243);

    final List<Map<String, dynamic>> bookings = [
      {
        'title': 'Aina wants to book Condo near KLCC',
        'subtitle': '24 Apr - 26 Apr • 2 guests',
        'status': 'Pending Approval',
        'statusColor': const Color(0xFFFF9800),
        'tenantName': 'Aina',
        'propertyName': 'Condo near KLCC',
        'checkIn': '24 Apr 2026',
        'checkOut': '26 Apr 2026',
        'guests': '2 guests',
        'payment': 'RM356',
        'note': 'Tenant prefers early check-in if available.',
      },
      {
        'title': 'Sara wants to stay at Cozy Family House',
        'subtitle': '30 Apr - 2 May • 4 guests',
        'status': 'New Request',
        'statusColor': const Color(0xFFC9A24A),
        'tenantName': 'Sara',
        'propertyName': 'Cozy Family House',
        'checkIn': '30 Apr 2026',
        'checkOut': '2 May 2026',
        'guests': '4 guests',
        'payment': 'RM500',
        'note': 'Family trip booking request.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryText,
        title: Text(
          "Booking Requests",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Review booking requests and approve suitable stays.",
              style: GoogleFonts.inter(
                fontSize: 13.2,
                fontWeight: FontWeight.w500,
                color: secondaryText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            ...bookings.map(
              (booking) => _bookingCard(
                context: context,
                dark: dark,
                glassCard: glassCard,
                glassBorder: glassBorder,
                booking: booking,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _bookingCard({
  required BuildContext context,
  required bool dark,
  required Color glassCard,
  required Color glassBorder,
  required Map<String, dynamic> booking,
}) {
  final Color statusColor = booking['statusColor'] as Color;

  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: glassCard,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: glassBorder),
      boxShadow: [
        BoxShadow(
          color: dark
              ? Colors.black.withOpacity(0.18)
              : Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.approval_rounded, color: statusColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['title'],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.8,
                      color: dark ? Colors.white : const Color(0xFF1D1D1F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    booking['subtitle'],
                    style: GoogleFonts.inter(
                      color: dark ? Colors.white70 : Colors.grey.shade700,
                      fontSize: 12.8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    booking['status'],
                    style: GoogleFonts.inter(
                      color: statusColor,
                      fontSize: 12.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _showBookingDetailsDialog(
              context: context,
              dark: dark,
              booking: booking,
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: glassBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            child: Text(
              "View Details",
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    ),
  );
}

void _showBookingDetailsDialog({
  required BuildContext context,
  required bool dark,
  required Map<String, dynamic> booking,
}) {
  final Color primaryText = Theme.of(context).colorScheme.onSurface;
  final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B6243);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: dark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        "Booking Details",
        style: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: primaryText,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow(
            'Tenant',
            booking['tenantName'],
            primaryText,
            secondaryText,
          ),
          _detailRow(
            'Property',
            booking['propertyName'],
            primaryText,
            secondaryText,
          ),
          _detailRow(
            'Check-in',
            booking['checkIn'],
            primaryText,
            secondaryText,
          ),
          _detailRow(
            'Check-out',
            booking['checkOut'],
            primaryText,
            secondaryText,
          ),
          _detailRow('Guests', booking['guests'], primaryText, secondaryText),
          _detailRow('Payment', booking['payment'], primaryText, secondaryText),
          _detailRow('Status', booking['status'], primaryText, secondaryText),
          _detailRow('Note', booking['note'], primaryText, secondaryText),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking rejected')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: dark ? Colors.white24 : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text(
                  "Reject",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking approved')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC9A24A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text(
                  "Approve",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _detailRow(
  String label,
  String value,
  Color primaryText,
  Color secondaryText,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: RichText(
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 13,
          color: secondaryText,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(fontWeight: FontWeight.w700, color: primaryText),
          ),
          TextSpan(text: value),
        ],
      ),
    ),
  );
}
