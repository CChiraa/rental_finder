import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'property_detail_screen.dart';

class TenantSavedPropertiesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> savedProperties;

  const TenantSavedPropertiesScreen({super.key, required this.savedProperties});

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);
    final Color screenBg = Theme.of(context).scaffoldBackgroundColor;
    final Color appBarBg = Theme.of(context).scaffoldBackgroundColor;
    final Color cardBg = dark
        ? const Color(0xFF1E1E1E)
        : Colors.white.withOpacity(0.88);

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryText),
        title: Text(
          'Saved Properties',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
      ),
      body: savedProperties.isEmpty
          ? Center(
              child: Text(
                'No saved properties yet.',
                style: GoogleFonts.inter(color: secondaryText, fontSize: 14),
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
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            property['image'],
                            width: 76,
                            height: 76,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 76,
                                height: 76,
                                color: dark
                                    ? const Color(0xFF2A2A2A)
                                    : const Color(0xFFF3E8D7),
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Color(0xFFB17B30),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property['title'] ?? '',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: primaryText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                property['location'] ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  color: secondaryText,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                property['price'] ?? '',
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
