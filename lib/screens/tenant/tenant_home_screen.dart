import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/tenant/property_detail_screen.dart';
import 'package:smart_rental_app/screens/tenant/tenant_feed_tab.dart';
import 'package:smart_rental_app/screens/tenant/tenant_map_tab.dart';
import 'package:smart_rental_app/screens/tenant/tenant_chat_tab.dart';
import 'package:smart_rental_app/screens/tenant/tenant_profile_screen.dart';
import 'package:smart_rental_app/screens/tenant/favorite_manager.dart';
import 'package:smart_rental_app/screens/tenant/p_notification_screen.dart';

class TenantHomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const TenantHomeScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<TenantHomeScreen> createState() => _TenantHomeScreenState();
}

class _TenantHomeScreenState extends State<TenantHomeScreen> {
  int _currentIndex = 0;
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Short-term',
    'Medium-term',
    'Long-term',
    'House',
    'Apartment',
    'Condo',
  ];

  final List<Map<String, dynamic>> properties = [
    {
      'id': 1,
      'title': 'Luxury Condo',
      'location': 'KLCC, Kuala Lumpur',
      'price': 'RM178/night',
      'image': 'images/bed3.jpg',
      'description':
          'A modern luxury condominium located in the heart of Kuala Lumpur, just minutes away from KLCC. Fully furnished with high-speed WiFi, swimming pool, gym, and 24-hour security. Perfect for business travelers and couples.',
      'lat': 3.1579,
      'lng': 101.7123,
      'postedBy': 'Alya Property',
      'type': 'Condo',
      'stayCategory': 'Short-term',
      'time': '2h ago',
    },
    {
      'id': 2,
      'title': 'Modern Apartment',
      'location': 'Bukit Bintang, Kuala Lumpur',
      'price': 'RM200/night',
      'image': 'images/bed1.jpg',
      'description':
          'Stylish apartment located in Bukit Bintang, surrounded by shopping malls, cafes, and nightlife. Comes with a fully equipped kitchen, balcony city view, and easy access to public transport.',
      'lat': 3.1466,
      'lng': 101.7113,
      'postedBy': 'Urban Stay',
      'type': 'Apartment',
      'stayCategory': 'Medium-term',
      'time': '5h ago',
    },
    {
      'id': 3,
      'title': 'Family House',
      'location': 'Damansara, Selangor',
      'price': 'RM350/night',
      'image': 'images/liv1.jpg',
      'description':
          'Spacious landed house ideal for families. Features 3 bedrooms, large living area, private parking, and a peaceful neighborhood. Close to schools, supermarkets, and parks.',
      'lat': 3.1490,
      'lng': 101.6169,
      'postedBy': 'Damansara Homes',
      'type': 'House',
      'stayCategory': 'Long-term',
      'time': 'Yesterday',
    },
  ];

  final List<Map<String, dynamic>> bookingHistory = [
    {
      'title': 'Luxury Condo',
      'location': 'KLCC, Kuala Lumpur',
      'date': '18 Apr 2026',
      'status': 'Pending',
      'price': 'RM178/night',
    },
    {
      'title': 'Modern Apartment',
      'location': 'Bukit Bintang, Kuala Lumpur',
      'date': '10 Apr 2026',
      'status': 'Successful',
      'price': 'RM200/night',
    },
  ];

  final List<Map<String, dynamic>> payments = [
    {
      'title': 'Luxury Condo Booking',
      'amount': 'RM178',
      'receiptUploaded': true,
      'status': 'Verified',
    },
    {
      'title': 'Modern Apartment Deposit',
      'amount': 'RM200',
      'receiptUploaded': true,
      'status': 'Pending',
    },
  ];

  List<Map<String, dynamic>> get filteredProperties {
    final query = searchController.text.trim().toLowerCase();

    return properties.where((property) {
      final title = property['title'].toString().toLowerCase();
      final location = property['location'].toString().toLowerCase();
      final type = property['type'].toString().toLowerCase();
      final stayCategory = property['stayCategory'].toString().toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          title.contains(query) ||
          location.contains(query) ||
          type.contains(query) ||
          stayCategory.contains(query);

      final matchesCategory =
          selectedCategory == 'All' ||
          property['type'] == selectedCategory ||
          property['stayCategory'] == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Map<String, dynamic>> get favoriteProperties {
    return FavoriteManager.favorites;
  }

  Set<int> get favoriteIds {
    return FavoriteManager.favorites
        .map<int>((property) => property['id'] as int)
        .toSet();
  }

  void toggleFavorite(int propertyId) {
    final property = properties.firstWhere(
      (item) => item['id'] == propertyId,
      orElse: () => <String, dynamic>{},
    );

    if (property.isEmpty) return;

    setState(() {
      FavoriteManager.toggleFavorite(property);
    });
  }

  bool isFavorite(Map<String, dynamic> property) {
    return FavoriteManager.isFavorite(property);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              _buildHomeTab(context),
              TenantFeedTab(
                properties: properties,
                favoriteIds: favoriteIds,
                onToggleFavorite: toggleFavorite,
              ),
              const TenantMapTab(),
              const TenantChatTab(),
              TenantProfileScreen(
                userName: widget.userName,
                userEmail: widget.userEmail,
                savedProperties: favoriteProperties,
                bookingHistory: bookingHistory,
                payments: payments,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, dark),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final shownProperties = filteredProperties;

    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);
    final Color mutedText = dark ? Colors.white60 : const Color(0xFF8B7355);

    final Color glassCard = dark
        ? const Color(0xFF1E293B).withOpacity(0.88)
        : Colors.white.withOpacity(0.88);

    final Color softCard = dark
        ? const Color(0xFF243247).withOpacity(0.9)
        : const Color(0xFFF8F1E7).withOpacity(0.95);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 270,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ),
                image: DecorationImage(
                  image: AssetImage('images/KL.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 270,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: dark
                      ? [
                          Colors.black.withOpacity(0.28),
                          const Color(0xFF0F172A).withOpacity(0.72),
                        ]
                      : [
                          Colors.black.withOpacity(0.18),
                          Colors.black.withOpacity(0.40),
                        ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.14),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Kuala Lumpur',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TenantNotificationScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.14),
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Hey, ${widget.userName}!',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 31,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tell us where you want to go',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 54,
                    decoration: BoxDecoration(
                      color: dark
                          ? Colors.white.withOpacity(0.10)
                          : Colors.white.withOpacity(0.94),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: dark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.transparent,
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: dark ? Colors.white70 : Colors.black54,
                        ),
                        hintText: 'Search location, property type...',
                        hintStyle: TextStyle(
                          color: dark ? Colors.white54 : Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFB8964F)
                              : (dark
                                    ? const Color(0xFF1E293B).withOpacity(0.88)
                                    : Colors.white.withOpacity(0.90)),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFD6B36A)
                                : (dark
                                      ? Colors.white.withOpacity(0.08)
                                      : Colors.white.withOpacity(0.55)),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFD6B36A,
                                    ).withOpacity(0.18),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (dark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'The most relevant',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) => _buildFavoriteSheet(context),
                      ).then((_) => setState(() {}));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: glassCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: dark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.white.withOpacity(0.35),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                            color: dark
                                ? Colors.black.withOpacity(0.20)
                                : const Color(0xFFD6B36A).withOpacity(0.14),
                          ),
                        ],
                      ),
                      child: Icon(
                        favoriteProperties.isNotEmpty
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: favoriteProperties.isNotEmpty
                            ? Colors.redAccent
                            : const Color(0xFFB8964F),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (shownProperties.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: glassCard,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    'No properties found.',
                    style: GoogleFonts.inter(
                      color: secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ...shownProperties.map(
                (property) => _propertyCard(context, property),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover new places',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 185,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: shownProperties.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final property = shownProperties[index];
                    return _discoverCard(context, property);
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, bool dark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF0F172A).withOpacity(0.96)
            : Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.06)
              : Colors.white.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.22)
                : Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFB8964F),
        unselectedItemColor: dark ? Colors.white54 : const Color(0xFF9A8B78),
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dynamic_feed_rounded),
            label: 'Feed',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _propertyCard(BuildContext context, Map<String, dynamic> property) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final bool favorite = isFavorite(property);

    final Color cardBg = dark
        ? const Color(0xFF1E293B).withOpacity(0.88)
        : Colors.white.withOpacity(0.93);

    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PropertyDetailScreen(property: property),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: cardBg,
          border: Border.all(
            color: dark
                ? const Color(0xFFD6B36A).withOpacity(0.08)
                : Colors.white.withOpacity(0.45),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 8),
              color: dark
                  ? Colors.black.withOpacity(0.22)
                  : const Color(0xFFD6B36A).withOpacity(0.12),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: Image.asset(
                    property['image'],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 160,
                        width: double.infinity,
                        color: dark
                            ? const Color(0xFF243247)
                            : const Color(0xFFF3E8D7),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: Color(0xFFB8964F),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      toggleFavorite(property['id']);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: dark
                            ? const Color(0xFF0F172A).withOpacity(0.92)
                            : Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        favorite
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: favorite
                            ? Colors.redAccent
                            : const Color(0xFFB8964F),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property['title'],
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 16,
                              color: Color(0xFFB8964F),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                property['location'],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _smallTag(context, property['type']),
                            _smallTag(context, property['stayCategory']),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    property['price'],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: const Color(0xFFB8964F),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _discoverCard(BuildContext context, Map<String, dynamic> property) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final bool favorite = isFavorite(property);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PropertyDetailScreen(property: property),
          ),
        ).then((_) => setState(() {}));
      },
      child: SizedBox(
        width: 160,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                property['image'],
                width: 160,
                height: 185,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 160,
                    height: 185,
                    color: dark
                        ? const Color(0xFF243247)
                        : const Color(0xFFF3E8D7),
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 40,
                      color: Color(0xFFB8964F),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: 160,
              height: 185,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.56),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  toggleFavorite(property['id']);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: dark
                        ? const Color(0xFF0F172A).withOpacity(0.92)
                        : Colors.white.withOpacity(0.95),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border_rounded,
                    color: favorite
                        ? Colors.redAccent
                        : const Color(0xFFB8964F),
                    size: 18,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property['location'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteSheet(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final favorites = favoriteProperties;
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF0F172A) : const Color(0xFFF8F1E7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: dark ? Colors.white30 : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.redAccent),
                  const SizedBox(width: 8),
                  Text(
                    'My Favorites',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: favorites.isEmpty
                    ? Center(
                        child: Text(
                          'No favorite places yet.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: secondaryText,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: favorites.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final property = favorites[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: dark
                                  ? const Color(0xFF1E293B).withOpacity(0.9)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  property['image'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: dark
                                          ? const Color(0xFF243247)
                                          : const Color(0xFFF3E8D7),
                                      child: const Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 24,
                                        color: Color(0xFFB8964F),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              title: Text(
                                property['title'],
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  color: primaryText,
                                ),
                              ),
                              subtitle: Text(
                                property['location'],
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  color: secondaryText,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  FavoriteManager.toggleFavorite(property);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallTag(BuildContext context, String text) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFFD6B36A).withOpacity(0.14)
            : const Color(0xFFF3E8D7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: dark ? const Color(0xFFEAD8BE) : const Color(0xFF8E6A39),
        ),
      ),
    );
  }
}
