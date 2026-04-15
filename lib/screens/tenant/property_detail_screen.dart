import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_rental_app/theme/theme.dart';
import 'package:smart_rental_app/screens/tenant/booking_tenant.dart';
import 'favorite_manager.dart'; // 🔥 IMPORT THIS

class PropertyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    LatLng location = LatLng(widget.property['lat'], widget.property['lng']);

    return Scaffold(
      body: Stack(
        children: [
          // 🖼️ IMAGE HEADER
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.asset(widget.property['image'], fit: BoxFit.cover),
          ),

          // 🔙 BACK BUTTON
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // ❤️ FAVORITE BUTTON
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: Icon(
                FavoriteManager.isFavorite(widget.property)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  FavoriteManager.toggleFavorite(widget.property);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      FavoriteManager.isFavorite(widget.property)
                          ? "Added to favorites ❤️"
                          : "Removed from favorites",
                    ),
                  ),
                );
              },
            ),
          ),

          // 📄 CONTENT
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            minChildSize: 0.6,
            builder: (_, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.property['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.blue),
                          Text(widget.property['location']),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        widget.property['price'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        widget.property['description'],
                        style: const TextStyle(fontSize: 15),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 🗺️ GOOGLE MAP
                      SizedBox(
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: location,
                            zoom: 14,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('property'),
                              position: location,
                            ),
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 📅 BOOK BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25),
                                ),
                              ),
                              builder: (context) =>
                                  BookingSheet(property: widget.property),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: Text(
                            'Book Now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: lightColorScheme.primary,
                            ),
                          ),
                        ),
                      ),
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
}
