import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantPaymentsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> payments;

  const TenantPaymentsScreen({super.key, required this.payments});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);
    final Color screenBg = Theme.of(context).scaffoldBackgroundColor;
    final Color cardBg = dark
        ? const Color(0xFF1E1E1E)
        : Colors.white.withOpacity(0.9);

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        backgroundColor: screenBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryText),
        title: Text(
          'Payments',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
      ),
      body: payments.isEmpty
          ? Center(
              child: Text(
                'No payments yet.',
                style: GoogleFonts.inter(color: secondaryText, fontSize: 14),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: payments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final payment = payments[index];
                final status = payment['status'] ?? 'Pending';
                final statusColor = _statusColor(status);

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: dark
                          ? Colors.white.withOpacity(0.06)
                          : Colors.transparent,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: dark
                            ? Colors.black.withOpacity(0.18)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['title'] ?? 'Payment',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Amount: ${payment['amount'] ?? 'RM0'}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: secondaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Receipt: ${payment['receiptUploaded'] == true ? 'Uploaded' : 'Not uploaded'}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: secondaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
