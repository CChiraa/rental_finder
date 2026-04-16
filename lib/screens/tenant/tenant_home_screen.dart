import 'package:flutter/material.dart';
import 'package:smart_rental_app/screens/tenant/property_detail_screen.dart';
import 'package:smart_rental_app/screens/tenant/profile_screen_tenant.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  HomeScreen({super.key, required this.userName});

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
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 250,
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
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          'Kuala Lumpur',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Hey, $userName!\nTell us where you want to go',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 10),
                          Text(
                            'Search...',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'The most relevant',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  Column(
                    children: properties.map((property) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PropertyDetailScreen(property: property),
                            ),
                          );
                        },

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ],
                          ),

                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                                child: Image.asset(
                                  property['image'],
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          property['title'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: Colors.blue,
                                            ),
                                            Text(property['location']),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      property['price'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Discover new places',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: properties.take(2).map((property) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PropertyDetailScreen(property: property),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                property['image'],
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoriteScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userName: userName,
                  userEmail: "$userName@gmail.com",
                ),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
