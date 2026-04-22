import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BcPaymentScreen extends StatelessWidget {
  final bool dark;
  final Color glassCard;
  final Color glassBorder;

  const BcPaymentScreen({
    super.key,
    required this.dark,
    required this.glassCard,
    required this.glassBorder,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B6243);

    final List<Map<String, dynamic>> payments = [
      {
        'title': 'Receipt uploaded for Studio Apartment',
        'subtitle': 'Tenant: Daniel • RM120 paid',
        'status': 'Review Payment',
        'statusColor': const Color(0xFF355CDE),
        'tenantName': 'Daniel',
        'propertyName': 'Studio Apartment',
        'amount': 'RM120',
        'paymentDate': '22 Apr 2026',
        'method': 'Online Transfer',
        'reference': 'TXN-120938',
        'note': 'Receipt image uploaded by tenant.',
      },
      {
        'title': 'Proof sent for Condo near KLCC',
        'subtitle': 'Tenant: Aina • RM178 paid',
        'status': 'Awaiting Confirmation',
        'statusColor': const Color(0xFFFF9800),
        'tenantName': 'Aina',
        'propertyName': 'Condo near KLCC',
        'amount': 'RM178',
        'paymentDate': '24 Apr 2026',
        'method': 'QR Payment',
        'reference': 'TXN-998271',
        'note': 'Waiting for landlord verification.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryText,
        title: Text(
          "Payment Review",
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
              "Check uploaded receipts and verify tenant payments.",
              style: GoogleFonts.inter(
                fontSize: 13.2,
                fontWeight: FontWeight.w500,
                color: secondaryText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            ...payments.map(
              (payment) => _paymentCard(
                context: context,
                dark: dark,
                glassCard: glassCard,
                glassBorder: glassBorder,
                payment: payment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _paymentCard({
  required BuildContext context,
  required bool dark,
  required Color glassCard,
  required Color glassBorder,
  required Map<String, dynamic> payment,
}) {
  final Color statusColor = payment['statusColor'] as Color;

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
              child: Icon(Icons.receipt_long_rounded, color: statusColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment['title'],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.8,
                      color: dark ? Colors.white : const Color(0xFF1D1D1F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    payment['subtitle'],
                    style: GoogleFonts.inter(
                      color: dark ? Colors.white70 : Colors.grey.shade700,
                      fontSize: 12.8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    payment['status'],
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
            onPressed: () => _showPaymentDetailsDialog(
              context: context,
              dark: dark,
              payment: payment,
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

void _showPaymentDetailsDialog({
  required BuildContext context,
  required bool dark,
  required Map<String, dynamic> payment,
}) {
  final Color primaryText = Theme.of(context).colorScheme.onSurface;
  final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B6243);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: dark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        "Payment Details",
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
            payment['tenantName'],
            primaryText,
            secondaryText,
          ),
          _detailRow(
            'Property',
            payment['propertyName'],
            primaryText,
            secondaryText,
          ),
          _detailRow('Amount', payment['amount'], primaryText, secondaryText),
          _detailRow(
            'Payment Date',
            payment['paymentDate'],
            primaryText,
            secondaryText,
          ),
          _detailRow('Method', payment['method'], primaryText, secondaryText),
          _detailRow(
            'Reference',
            payment['reference'],
            primaryText,
            secondaryText,
          ),
          _detailRow('Status', payment['status'], primaryText, secondaryText),
          _detailRow('Note', payment['note'], primaryText, secondaryText),
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
                    const SnackBar(content: Text('Payment rejected')),
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
                    const SnackBar(content: Text('Payment verified')),
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
                  "Verify",
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
