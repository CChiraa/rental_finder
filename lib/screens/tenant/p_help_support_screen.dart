import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantHelpSupportScreen extends StatelessWidget {
  const TenantHelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I book a property?',
        'answer':
            'Open a property, choose your dates, confirm booking, then proceed with payment.',
      },
      {
        'question': 'How does QR payment work?',
        'answer':
            'Scan the QR code, complete your transfer, then upload your receipt for verification.',
      },
      {
        'question': 'Why is my booking still pending?',
        'answer':
            'Pending means your payment or booking request is still under review by the landlord or admin.',
      },
      {
        'question': 'How do I save a property?',
        'answer':
            'Tap the favourite icon on the home page or property details page.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F1E7),
        elevation: 0,
        title: Text(
          'Help & Support',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2C2621),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Us',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: const Color(0xFF2C2621),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: support@yuppieslah.com\nPhone: +60 12-345 6789',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF7B664C),
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
              color: const Color(0xFF2C2621),
            ),
          ),
          const SizedBox(height: 12),
          ...faqs.map(
            (faq) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: ExpansionTile(
                title: Text(
                  faq['question']!,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C2621),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      faq['answer']!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF7B664C),
                        height: 1.5,
                      ),
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
