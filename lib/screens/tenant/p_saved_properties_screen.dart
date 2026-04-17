import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'property_detail_screen.dart';

class TenantSavedPropertiesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> savedProperties;

  const TenantSavedPropertiesScreen({super.key, required this.savedProperties});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F1E7),
        elevation: 0,
        title: Text(
          'Saved Properties',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2C2621),
          ),
        ),
      ),
      body: savedProperties.isEmpty
          ? Center(
              child: Text(
                'No saved properties yet.',
                style: GoogleFonts.inter(
                  color: const Color(0xFF7B664C),
                  fontSize: 14,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: savedProperties.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final property = savedProperties[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PropertyDetailScreen(property: property),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.88),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            property['image'],
                            width: 76,
                            height: 76,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property['title'],
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: const Color(0xFF2C2621),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                property['location'],
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  color: const Color(0xFF7B664C),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                property['price'],
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFB17B30),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
