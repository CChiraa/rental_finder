import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/tenant/property_detail_screen.dart';
import 'package:smart_rental_app/screens/tenant/tenant_feed_tab.dart';
import 'package:smart_rental_app/screens/tenant/tenant_map_tab.dart';
import 'package:smart_rental_app/screens/tenant/tenant_chat_tab.dart';
import 'package:smart_rental_app/screens/tenant/tenant_profile_screen.dart';
import 'package:smart_rental_app/screens/tenant/favorite_manager.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E7),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeTab(),
            TenantFeedTab(
              properties: properties,
              favoriteIds: favoriteIds,
              onToggleFavorite: toggleFavorite,
            ),
            TenantMapTab(properties: properties),
            const TenantChatTab(),
            TenantProfileScreen(
              userName: widget.userName,
              userEmail: '${widget.userName}@gmail.com',
              savedProperties: favoriteProperties,
              bookingHistory: bookingHistory,
              payments: payments,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeTab() {
    final shownProperties = filteredProperties;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 260,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                image: DecorationImage(
                  image: AssetImage('images/KL.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 18),
                      SizedBox(width: 5),
                      Text(
                        'Kuala Lumpur',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Hey, ${widget.userName}!',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tell us where you want to go',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: Colors.black54),
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
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
                          color: isSelected ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'The most relevant',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2B2118),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFFF8F1E7),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(26),
                          ),
                        ),
                        builder: (context) => _buildFavoriteSheet(),
                      ).then((_) => setState(() {}));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.06),
                          ),
                        ],
                      ),
                      child: Icon(
                        favoriteProperties.isNotEmpty
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: const Color(0xFFB17B30),
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
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    'No properties found.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6B5338),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ...shownProperties.map((property) => _propertyCard(property)),
              const SizedBox(height: 20),
              Text(
                'Discover new places',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2B2118),
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
                    return _discoverCard(property);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
        selectedItemColor: const Color(0xFFB17B30),
        unselectedItemColor: const Color(0xFF9A8B78),
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

  Widget _propertyCard(Map<String, dynamic> property) {
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.grey.withOpacity(0.18)),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.asset(
                    property['image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                        color: Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        favorite
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: favorite
                            ? Colors.redAccent
                            : const Color(0xFFB17B30),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
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
                            color: const Color(0xFF2B2118),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 16,
                              color: Color(0xFFB17B30),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                property['location'],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF6F5A40),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _smallTag(property['type']),
                            _smallTag(property['stayCategory']),
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
  }

  Widget _discoverCard(Map<String, dynamic> property) {
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
                    Colors.black.withOpacity(0.50),
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
                    color: Colors.white.withOpacity(0.95),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border_rounded,
                    color: favorite
                        ? Colors.redAccent
                        : const Color(0xFFB17B30),
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

  Widget _buildFavoriteSheet() {
    final favorites = favoriteProperties;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
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
                    color: const Color(0xFF2B2118),
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
                          color: const Color(0xFF6F5A40),
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
                            color: Colors.white,
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
                              ),
                            ),
                            title: Text(
                              property['title'],
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              property['location'],
                              style: GoogleFonts.inter(fontSize: 12.5),
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
}
