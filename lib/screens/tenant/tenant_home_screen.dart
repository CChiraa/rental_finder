import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/screens/tenant/property_detail_screen.dart';
import 'package:smart_rental_app/screens/tenant/profile_screen_tenant.dart';
import 'package:smart_rental_app/screens/tenant/chat_manager.dart';
import 'package:smart_rental_app/screens/tenant/chat_detail_screen.dart';

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
  final Set<int> favoriteIds = {};

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
    return properties
        .where((property) => favoriteIds.contains(property['id']))
        .toList();
  }

  void toggleFavorite(int propertyId) {
    setState(() {
      if (favoriteIds.contains(propertyId)) {
        favoriteIds.remove(propertyId);
      } else {
        favoriteIds.add(propertyId);
      }
    });
  }

  bool isFavorite(int propertyId) {
    return favoriteIds.contains(propertyId);
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
            _buildFeedTab(),
            _buildMapTab(),
            _buildChatTab(),
            _buildProfileTab(),
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
                      );
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
                        favoriteIds.isNotEmpty
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

  Widget _buildFeedTab() {
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

  Widget _buildMapTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Map Search',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2B2118),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Later you can connect Google Maps and place all landlord listings here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF6F5A40),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.map_rounded,
                size: 60,
                color: Color(0xFFB17B30),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: properties.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final property = properties[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFFB17B30),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${property['title']} • ${property['location']}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4A3B2B),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    final chats = ChatManager.chats;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 8),
        Text(
          'Chats',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2B2118),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Talk to landlords directly here.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF6F5A40),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 18),

        if (chats.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              'No chats yet. Start from a property detail screen.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6F5A40),
              ),
            ),
          ),

        ...chats.map(
          (chat) => Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(22),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: (chat['propertyImage'] ?? '').toString().isNotEmpty
                    ? Image.asset(
                        chat['propertyImage'],
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 52,
                        height: 52,
                        color: const Color(0xFFF3E8D7),
                        child: const Icon(
                          Icons.home_work_rounded,
                          color: Color(0xFFB17B30),
                        ),
                      ),
              ),
              title: Text(
                chat['landlord'] ?? 'Landlord',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                chat['lastMessage'] ?? chat['propertyTitle'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(color: const Color(0xFF7B664C)),
              ),
              trailing: Text(
                chat['lastTime'] ?? '',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF9A8B78),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatDetailScreen(chat: chat),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab() {
    return ProfileScreen(
      userName: widget.userName,
      userEmail: '${widget.userName}@gmail.com',
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
    final int propertyId = property['id'];
    final bool favorite = isFavorite(propertyId);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PropertyDetailScreen(property: property),
          ),
        );
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
                      toggleFavorite(propertyId);
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
    final int propertyId = property['id'];
    final bool favorite = isFavorite(propertyId);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PropertyDetailScreen(property: property),
          ),
        );
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
                  toggleFavorite(propertyId);
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
                  onPressed: () => toggleFavorite(propertyId),
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
                  onTap: () => toggleFavorite(propertyId),
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
                              onPressed: () => toggleFavorite(property['id']),
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
