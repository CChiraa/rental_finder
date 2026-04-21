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
            _paymentCard(
              dark: dark,
              glassCard: glassCard,
              glassBorder: glassBorder,
              title: "Receipt uploaded for Studio Apartment",
              subtitle: "Tenant: Daniel • RM120 paid",
              status: "Review Payment",
              statusColor: const Color(0xFF355CDE),
            ),
            _paymentCard(
              dark: dark,
              glassCard: glassCard,
              glassBorder: glassBorder,
              title: "Proof sent for Condo near KLCC",
              subtitle: "Tenant: Aina • RM178 paid",
              status: "Awaiting Confirmation",
              statusColor: const Color(0xFFFF9800),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _paymentCard({
  required bool dark,
  required Color glassCard,
  required Color glassBorder,
  required String title,
  required String subtitle,
  required String status,
  required Color statusColor,
}) {
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
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.8,
                      color: dark ? Colors.white : const Color(0xFF1D1D1F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: dark ? Colors.white70 : Colors.grey.shade700,
                      fontSize: 12.8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status,
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
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: glassBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC9A24A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
