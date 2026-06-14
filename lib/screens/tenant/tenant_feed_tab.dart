import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/services/property_service.dart';

class TenantFeedTab extends StatelessWidget {
  final List<Map<String, dynamic>> properties;
  final Set<int> favoriteIds;
  final Function(int) onToggleFavorite;

  const TenantFeedTab({
    super.key,
    required this.properties,
    required this.favoriteIds,
    required this.onToggleFavorite,
  });

  bool isFavorite(int propertyId) => favoriteIds.contains(propertyId);

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    final Gradient backgroundGradient = dark
        ? const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF162033), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFF8F1E7), Color(0xFFF2E6D5), Color(0xFFEAD8BE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: PropertyService().getPropertiesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load properties',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(
                "No property posts available yet",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            children: [
              Text(
                'Feed',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Latest property posts from landlords',
                style: GoogleFonts.inter(fontSize: 14, color: secondaryText),
              ),
              const SizedBox(height: 18),
              ...docs.map((doc) {
                final Map<String, dynamic> property = doc.data();

                property['id'] = doc.id.hashCode;
                property['docId'] = doc.id;

                return _buildFeedCard(context, property);
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeedCard(BuildContext context, Map<String, dynamic> property) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    final int propertyId = property['id'] ?? 0;
    final bool favorite = isFavorite(propertyId);

    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);
    final Color mutedText = dark ? Colors.white60 : const Color(0xFF8B7355);

    final Color cardBg = dark
        ? const Color(0xFF1E293B).withOpacity(0.88)
        : Colors.white.withOpacity(0.92);

    final Color headerBg = dark
        ? const Color(0xFF243247).withOpacity(0.9)
        : const Color(0xFFF8F1E7).withOpacity(0.95);

    final Color tagBg = dark
        ? const Color(0xFFD6B36A).withOpacity(0.14)
        : const Color(0xFFF3E8D7);

    final Color dividerColor = dark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.08);

    final Color goldColor = const Color(0xFFB8964F);

    final List images = property['images'] ?? [];
    final String imageUrl = images.isNotEmpty ? images.first.toString() : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: dark
              ? const Color(0xFFD6B36A).withOpacity(0.08)
              : Colors.white.withOpacity(0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.24)
                : const Color(0xFFD6B36A).withOpacity(0.14),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dark
                        ? const Color(0xFF243247)
                        : Colors.white.withOpacity(0.9),
                    border: Border.all(
                      color: const Color(0xFFD6B36A),
                      width: 1.4,
                    ),
                  ),
                  child: const Icon(
                    Icons.home_work_rounded,
                    color: Color(0xFFB8964F),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property['landlordName'] ?? 'Landlord Post',
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'Just now',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: mutedText,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(Icons.public, size: 14, color: mutedText),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => onToggleFavorite(propertyId),
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border_rounded,
                    color: favorite ? Colors.redAccent : goldColor,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🏡 ${property['title'] ?? 'Property'} now available at ${property['location'] ?? 'Unknown location'}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  property['description'] ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: secondaryText,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _smallTag(
                      text: property['type'] ?? '',
                      bgColor: tagBg,
                      textColor: dark
                          ? const Color(0xFFEAD8BE)
                          : const Color(0xFF8E6A39),
                    ),
                    _smallTag(
                      text: property['stayCategory'] ?? '',
                      bgColor: tagBg,
                      textColor: dark
                          ? const Color(0xFFEAD8BE)
                          : const Color(0xFF8E6A39),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  property['price'] ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: goldColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 220,
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _emptyImageBox(dark);
                    },
                  )
                : _emptyImageBox(dark),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: Row(
              children: [
                Text(
                  '${favorite ? 25 : 24} interested',
                  style: GoogleFonts.inter(fontSize: 12.5, color: mutedText),
                ),
                const Spacer(),
                Text(
                  '8 comments',
                  style: GoogleFonts.inter(fontSize: 12.5, color: mutedText),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: dividerColor),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _feedAction(
                  icon: favorite
                      ? Icons.favorite
                      : Icons.favorite_border_rounded,
                  label: 'Interested',
                  onTap: () => onToggleFavorite(propertyId),
                  color: favorite ? Colors.redAccent : mutedText,
                ),
                _feedAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Comment',
                  onTap: () {},
                  color: mutedText,
                ),
                _feedAction(
                  icon: Icons.send_outlined,
                  label: 'Share',
                  onTap: () {},
                  color: mutedText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyImageBox(bool dark) {
    return Container(
      height: 220,
      width: double.infinity,
      color: dark ? const Color(0xFF243247) : const Color(0xFFF3E8D7),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 40,
        color: Color(0xFFB8964F),
      ),
    );
  }

  Widget _smallTag({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _feedAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20, color: color),
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: color,
        overlayColor: color.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
