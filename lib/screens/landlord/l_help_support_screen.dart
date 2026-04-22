import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandlordHelpSupportScreen extends StatelessWidget {
  const LandlordHelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I manage my property listings?',
        'answer':
            'Open My Properties to review, update, and manage your rental listings.',
      },
      {
        'question': 'How do I verify tenant bookings?',
        'answer':
            'Go to Booking Management to review booking requests and payment status.',
      },
      {
        'question': 'How do I track my earnings?',
        'answer':
            'Open Earnings & Payouts to see your income records and transaction summary.',
      },
      {
        'question': 'How do notifications work?',
        'answer':
            'You will receive alerts for new bookings, messages, and payment activity.',
      },
    ];

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
          'Help & Support',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
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
                  'Contact Us',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: landlord@yuppieslah.com\nPhone: +60 12-345 6789',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: secondaryText,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Frequently Asked Questions',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 12),
          ...faqs.map(
            (faq) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
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
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: const Color(0xFFB17B30),
                  collapsedIconColor: const Color(0xFFB17B30),
                  title: Text(
                    faq['question']!,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faq['answer']!,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: secondaryText,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
