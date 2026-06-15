import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantFeedTab extends StatelessWidget {
  final List<Map<String, dynamic>> properties;
  final Set<int> favoriteIds;
  final Function(int)? onToggleFavorite;

  const TenantFeedTab({
    super.key,
    this.properties = const [],
    this.favoriteIds = const <int>{},
    this.onToggleFavorite,
  });

  Future<void> _toggleLike(String feedId, bool isLiked) async {
    await FirebaseFirestore.instance.collection('feeds').doc(feedId).update({
      'likesCount': FieldValue.increment(isLiked ? -1 : 1),
    });
  }

  Future<void> _incrementComments(String feedId) async {
    await FirebaseFirestore.instance.collection('feeds').doc(feedId).update({
      'commentsCount': FieldValue.increment(1),
    });
  }

  Future<void> _showCommentDialog(BuildContext context, String feedId) async {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SizedBox(
            height: 500,
            child: Column(
              children: [
                Text(
                  'Comments',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('feeds')
                        .doc(feedId)
                        .collection('comments')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final docs = snapshot.data?.docs ?? [];

                      if (docs.isEmpty) {
                        return const Center(child: Text('No comments yet'));
                      }

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final comment = docs[index].data();

                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(comment['comment'] ?? ''),
                          );
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: 'Write a comment...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        final text = commentController.text.trim();
                        if (text.isEmpty) return;

                        await FirebaseFirestore.instance
                            .collection('feeds')
                            .doc(feedId)
                            .collection('comments')
                            .add({
                              'comment': text,
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                        await _incrementComments(feedId);
                        commentController.clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      commentController.dispose();
    });
  }

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
        stream: FirebaseFirestore.instance
            .collection('feeds')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load feed posts',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

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
                'Latest posts from landlords',
                style: GoogleFonts.inter(fontSize: 14, color: secondaryText),
              ),
              const SizedBox(height: 22),

              if (docs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Text(
                      'No feed posts available yet',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              else
                ...docs.map((doc) {
                  final feed = doc.data();
                  feed['docId'] = doc.id;
                  return _buildFeedCard(context, feed);
                }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeedCard(BuildContext context, Map<String, dynamic> feed) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    final String feedId = feed['docId'].toString();
    final int feedHashId = feedId.hashCode;
    final bool liked = favoriteIds.contains(feedHashId);

    final int likesCount = feed['likesCount'] ?? 0;
    final int commentsCount = feed['commentsCount'] ?? 0;

    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);
    final Color mutedText = dark ? Colors.white60 : const Color(0xFF8B7355);

    final Color cardBg = dark
        ? const Color(0xFF1E293B).withOpacity(0.88)
        : Colors.white.withOpacity(0.92);

    final Color headerBg = dark
        ? const Color(0xFF243247).withOpacity(0.9)
        : const Color(0xFFF8F1E7).withOpacity(0.95);

    final Color dividerColor = dark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.08);

    final String imageUrl = (feed['imageUrl'] ?? '').toString();

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
                const CircleAvatar(
                  backgroundColor: Color(0xFFF3E8D7),
                  child: Icon(Icons.person, color: Color(0xFFB8964F)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    feed['landlordName'] ?? 'Landlord',
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
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
                  feed['title'] ?? 'Feed Post',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feed['caption'] ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: secondaryText,
                    height: 1.5,
                  ),
                ),
                if ((feed['propertyName'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Property: ${feed['propertyName']}',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFB8964F),
                    ),
                  ),
                ],
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
                  '$likesCount likes',
                  style: GoogleFonts.inter(fontSize: 12.5, color: mutedText),
                ),
                const Spacer(),
                Text(
                  '$commentsCount comments',
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
                  icon: liked ? Icons.favorite : Icons.favorite_border_rounded,
                  label: 'Like',
                  onTap: () async {
                    onToggleFavorite?.call(feedHashId);
                    await _toggleLike(feedId, liked);
                  },
                  color: liked ? Colors.redAccent : mutedText,
                ),
                _feedAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Comment',
                  onTap: () => _showCommentDialog(context, feedId),
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
    );
  }
}
