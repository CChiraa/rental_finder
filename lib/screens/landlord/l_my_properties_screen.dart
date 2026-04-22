import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandlordMyPropertiesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> properties;

  const LandlordMyPropertiesScreen({super.key, required this.properties});

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
          'My Properties',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        iconTheme: IconThemeData(color: primaryText),
      ),
      body: properties.isEmpty
          ? Center(
              child: Text(
                'No properties yet',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: dark
                              ? const Color(0xFF243247)
                              : const Color(0xFFF3E8D7),
                          borderRadius: BorderRadius.circular(16),
                          image:
                              property['image'] != null &&
                                  property['image'].toString().isNotEmpty
                              ? DecorationImage(
                                  image: AssetImage(property['image']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child:
                            property['image'] == null ||
                                property['image'].toString().isEmpty
                            ? const Icon(
                                Icons.home_work_outlined,
                                color: Color(0xFFB17B30),
                                size: 34,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property['title'] ?? 'Property',
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: primaryText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              property['location'] ?? 'Location not available',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: secondaryText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              property['price'] ?? 'Price not available',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFB17B30),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _miniBadge('Active'),
                                const SizedBox(width: 8),
                                _miniBadge('Listed'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _miniBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD6B36A).withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFB17B30),
        ),
      ),
    );
  }
}
