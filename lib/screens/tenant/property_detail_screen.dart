import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_rental_app/screens/tenant/booking_tenant.dart';
import 'package:smart_rental_app/screens/tenant/chat_detail_screen.dart';
import 'package:smart_rental_app/screens/tenant/chat_manager.dart';
import 'favorite_manager.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  bool isChatSelected = false;

  bool get isFavorite => FavoriteManager.isFavorite(widget.property);

  LatLng get location => LatLng(
    (widget.property['lat'] ?? 0.0).toDouble(),
    (widget.property['lng'] ?? 0.0).toDouble(),
  );

  void _toggleFavorite() {
    setState(() {
      FavoriteManager.toggleFavorite(widget.property);
    });

    final bool nowFavorite = FavoriteManager.isFavorite(widget.property);
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: dark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFF2B2118),
        content: Text(
          nowFavorite ? 'Added to favorites ❤️' : 'Removed from favorites',
          style: GoogleFonts.inter(color: Colors.white),
        ),
      ),
    );
  }

  void _openChat() {
    final chat = ChatManager.getOrCreateChat(widget.property);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatDetailScreen(chat: chat)),
    ).then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _openBookingSheet() async {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF121212) : const Color(0xFFF8F1E7),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: BookingSheet(property: widget.property),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFB17B30),
          content: Text(
            'Booking submitted successfully',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF6F5A40);
    final Color sheetBg = dark
        ? const Color(0xFF121212)
        : const Color(0xFFF8F1E7);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SizedBox(
            height: 330,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  widget.property['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: dark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFF3E8D7),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: Color(0xFFB17B30),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.28),
                        Colors.black.withOpacity(0.12),
                        Colors.black.withOpacity(0.45),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _topIconButton(
                    context: context,
                    dark: dark,
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  _topIconButton(
                    context: context,
                    dark: dark,
                    icon: isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    iconColor: isFavorite
                        ? Colors.redAccent
                        : (dark ? Colors.white : const Color(0xFF2B2118)),
                    onTap: _toggleFavorite,
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.63,
            minChildSize: 0.63,
            maxChildSize: 0.92,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: sheetBg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(34),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: dark
                                ? Colors.white24
                                : Colors.brown.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.property['title'] ?? 'Property',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: primaryText,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE6BC6D), Color(0xFFBE8233)],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFC89243,
                                  ).withOpacity(0.18),
                                  blurRadius: 14,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Text(
                              widget.property['price'] ?? 'RM 0',
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 18,
                            color: Color(0xFFB17B30),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.property['location'] ?? 'Unknown location',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: secondaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (widget.property['type'] != null)
                            _infoTag(context, widget.property['type']),
                          if (widget.property['stayCategory'] != null)
                            _infoTag(context, widget.property['stayCategory']),
                          if (widget.property['postedBy'] != null)
                            _infoTag(context, widget.property['postedBy']),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _sectionTitle(context, 'Description'),
                      const SizedBox(height: 10),
                      _softCard(
                        context: context,
                        child: Text(
                          widget.property['description'] ??
                              'No description provided.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.65,
                            color: dark
                                ? Colors.white70
                                : const Color(0xFF5E4B36),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      _sectionTitle(context, 'Location'),
                      const SizedBox(height: 10),
                      _softCard(
                        context: context,
                        padding: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            height: 220,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: location,
                                zoom: 14,
                              ),
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              markers: {
                                Marker(
                                  markerId: const MarkerId('property'),
                                  position: location,
                                  infoWindow: InfoWindow(
                                    title:
                                        widget.property['title'] ?? 'Property',
                                    snippet:
                                        widget.property['location'] ??
                                        'Unknown location',
                                  ),
                                ),
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isChatSelected = true;
                                });
                                _openChat();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isChatSelected
                                      ? const Color(0xFFB17B30)
                                      : (dark
                                            ? Colors.white.withOpacity(0.04)
                                            : Colors.white.withOpacity(0.6)),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isChatSelected
                                        ? const Color(0xFFB17B30)
                                        : (dark
                                              ? Colors.white.withOpacity(0.12)
                                              : const Color(
                                                  0xFFD6B36A,
                                                ).withOpacity(0.75)),
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: isChatSelected
                                          ? Colors.white
                                          : const Color(0xFFB17B30),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Chat',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        color: isChatSelected
                                            ? Colors.white
                                            : (dark
                                                  ? Colors.white
                                                  : const Color(0xFF7B5E35)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isChatSelected = false;
                                });
                                _openBookingSheet();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: !isChatSelected
                                      ? const Color(0xFFB17B30)
                                      : (dark
                                            ? Colors.white.withOpacity(0.04)
                                            : Colors.white.withOpacity(0.6)),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: !isChatSelected
                                        ? const Color(0xFFB17B30)
                                        : (dark
                                              ? Colors.white.withOpacity(0.12)
                                              : const Color(
                                                  0xFFD6B36A,
                                                ).withOpacity(0.75)),
                                    width: 1.2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Book Now',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: !isChatSelected
                                          ? Colors.white
                                          : (dark
                                                ? Colors.white
                                                : const Color(0xFF7B5E35)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _topIconButton({
    required BuildContext context,
    required bool dark,
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF2B2118),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: dark
            ? Colors.black.withOpacity(0.35)
            : Colors.white.withOpacity(0.82),
        shape: BoxShape.circle,
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.5),
        ),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: iconColor),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _softCard({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.65),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.14)
                : const Color(0xFFC89243).withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _infoTag(BuildContext context, String text) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF2A2A2A) : const Color(0xFFF3E8D7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: dark ? const Color(0xFF9DB7E8) : const Color(0xFF8E6A39),
        ),
      ),
    );
  }
}
