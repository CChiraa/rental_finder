import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      children: [
        Text(
          'Feed',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2B2118),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Latest property posts from landlords',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF6F5A40),
          ),
        ),
        const SizedBox(height: 16),
        ...properties.map((property) => _facebookStyleFeedCard(property)),
      ],
    );
  }

  Widget _facebookStyleFeedCard(Map<String, dynamic> property) {
    final int propertyId = property['id'];
    final bool favorite = isFavorite(propertyId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFFE6BC6D),
                  child: Icon(Icons.home_work_rounded, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property['postedBy'] ?? 'Landlord Post',
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2B2118),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            property['time'] ?? '2h ago',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF8F7A61),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.public,
                            size: 14,
                            color: Color(0xFF8F7A61),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => onToggleFavorite(propertyId),
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border_rounded,
                    color: favorite
                        ? Colors.redAccent
                        : const Color(0xFFB17B30),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🏡 ${property['title']} now available at ${property['location']}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2B2118),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  property['description'],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF6F5A40),
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _smallTag(property['type']),
                    _smallTag(property['stayCategory']),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  property['price'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB17B30),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.asset(
              property['image'],
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: Row(
              children: [
                Text(
                  '${favorite ? 25 : 24} interested',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF8F7A61),
                  ),
                ),
                const Spacer(),
                Text(
                  '8 comments',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF8F7A61),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _feedAction(
                  favorite ? Icons.favorite : Icons.favorite_border_rounded,
                  'Interested',
                  onTap: () => onToggleFavorite(propertyId),
                  color: favorite ? Colors.redAccent : const Color(0xFF7B664C),
                ),
                _feedAction(
                  Icons.chat_bubble_outline_rounded,
                  'Comment',
                  onTap: () {},
                ),
                _feedAction(Icons.send_outlined, 'Share', onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8D7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF8E6A39),
        ),
      ),
    );
  }

  Widget _feedAction(
    IconData icon,
    String label, {
    required VoidCallback onTap,
    Color color = const Color(0xFF7B664C),
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
    );
  }
}
