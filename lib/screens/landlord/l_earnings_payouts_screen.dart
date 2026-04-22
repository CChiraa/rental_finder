import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandlordEarningsPayoutsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> payouts;

  const LandlordEarningsPayoutsScreen({super.key, required this.payouts});

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color screenBg = Theme.of(context).scaffoldBackgroundColor;
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);
    final Color cardBg = dark
        ? const Color(0xFF1E293B).withOpacity(0.92)
        : Colors.white.withOpacity(0.88);

    double totalIncome = 0;
    for (final item in payouts) {
      final raw = item['amount'];
      if (raw is num) {
        totalIncome += raw.toDouble();
      } else if (raw is String) {
        totalIncome +=
            double.tryParse(raw.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      }
    }

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        backgroundColor: screenBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Earnings & Payouts',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        iconTheme: IconThemeData(color: primaryText),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Income',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'RM ${totalIncome.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    color: const Color(0xFFB17B30),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (payouts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  'No payout records yet',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            ...payouts.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6B36A).withOpacity(0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Color(0xFFB17B30),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] ?? 'Payout Record',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['date'] ?? 'Date not available',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item['amount']?.toString() ?? 'RM 0.00',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB17B30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
