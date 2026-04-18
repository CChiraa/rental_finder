import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TenantMapTab extends StatefulWidget {
  final List<Map<String, dynamic>> properties;

  const TenantMapTab({super.key, required this.properties});

  @override
  State<TenantMapTab> createState() => _TenantMapTabState();
}

class _TenantMapTabState extends State<TenantMapTab> {
  final TextEditingController searchController = TextEditingController();
  GoogleMapController? mapController;

  String searchQuery = '';
  int? selectedPropertyId;

  static const LatLng klCenter = LatLng(3.1390, 101.6869);

  final List<Map<String, dynamic>> publicTransportStations = const [
    {
      'id': 'kl_sentral',
      'name': 'KL Sentral',
      'location': 'Brickfields, Kuala Lumpur',
      'lat': 3.1343,
      'lng': 101.6861,
      'type': 'Transit Hub',
    },
    {
      'id': 'pasar_seni',
      'name': 'Pasar Seni',
      'location': 'City Centre, Kuala Lumpur',
      'lat': 3.1424,
      'lng': 101.6953,
      'type': 'LRT / MRT',
    },
    {
      'id': 'masjid_jamek',
      'name': 'Masjid Jamek',
      'location': 'Jalan Tun Perak, Kuala Lumpur',
      'lat': 3.1486,
      'lng': 101.6958,
      'type': 'LRT',
    },
    {
      'id': 'bukit_bintang',
      'name': 'Bukit Bintang',
      'location': 'Bukit Bintang, Kuala Lumpur',
      'lat': 3.1469,
      'lng': 101.7113,
      'type': 'MRT / Monorail',
    },
    {
      'id': 'hang_tuah',
      'name': 'Hang Tuah',
      'location': 'Jalan Hang Tuah, Kuala Lumpur',
      'lat': 3.1407,
      'lng': 101.7071,
      'type': 'LRT / Monorail',
    },
    {
      'id': 'titiwangsa',
      'name': 'Titiwangsa',
      'location': 'Titiwangsa, Kuala Lumpur',
      'lat': 3.1738,
      'lng': 101.6960,
      'type': 'LRT / MRT / Monorail',
    },
    {
      'id': 'bandaraya',
      'name': 'Bandaraya',
      'location': 'Jalan Tuanku Abdul Rahman, Kuala Lumpur',
      'lat': 3.1593,
      'lng': 101.6948,
      'type': 'LRT',
    },
    {
      'id': 'trx',
      'name': 'TRX',
      'location': 'Tun Razak Exchange, Kuala Lumpur',
      'lat': 3.1428,
      'lng': 101.7191,
      'type': 'MRT',
    },
  ];

  List<Map<String, dynamic>> get filteredProperties {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) return widget.properties;

    return widget.properties.where((property) {
      final title = (property['title'] ?? '').toString().toLowerCase();
      final location = (property['location'] ?? '').toString().toLowerCase();
      final type = (property['type'] ?? '').toString().toLowerCase();
      final stayCategory = (property['stayCategory'] ?? '')
          .toString()
          .toLowerCase();

      return title.contains(query) ||
          location.contains(query) ||
          type.contains(query) ||
          stayCategory.contains(query);
    }).toList();
  }

  Set<Marker> get propertyMarkers {
    return filteredProperties
        .where((property) => property['lat'] != null && property['lng'] != null)
        .map((property) {
          final int propertyId = property['id'] ?? 0;
          final double lat = (property['lat'] as num).toDouble();
          final double lng = (property['lng'] as num).toDouble();

          final nearest = getNearestStation(lat, lng);

          return Marker(
            markerId: MarkerId('property_$propertyId'),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: property['title'] ?? 'Property',
              snippet:
                  'Nearest: ${nearest['name']} (${nearest['distanceText']})',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRose,
            ),
            onTap: () {
              setState(() {
                selectedPropertyId = propertyId;
              });
            },
          );
        })
        .toSet();
  }

  Set<Marker> get transportMarkers {
    return publicTransportStations.map((station) {
      return Marker(
        markerId: MarkerId(station['id'].toString()),
        position: LatLng(
          (station['lat'] as num).toDouble(),
          (station['lng'] as num).toDouble(),
        ),
        infoWindow: InfoWindow(
          title: station['name'].toString(),
          snippet: '${station['type']} • ${station['location']}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    }).toSet();
  }

  Set<Marker> get allMarkers => {...propertyMarkers, ...transportMarkers};

  void moveToProperty(Map<String, dynamic> property) {
    if (property['lat'] == null || property['lng'] == null) return;

    final double lat = (property['lat'] as num).toDouble();
    final double lng = (property['lng'] as num).toDouble();
    final int propertyId = property['id'] ?? 0;

    setState(() {
      selectedPropertyId = propertyId;
    });

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15),
      ),
    );
  }

  double calculateDistanceKm(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadius = 6371;

    final double dLat = _degToRad(lat2 - lat1);
    final double dLng = _degToRad(lng2 - lng1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degToRad(double degree) {
    return degree * pi / 180;
  }

  Map<String, dynamic> getNearestStation(
    double propertyLat,
    double propertyLng,
  ) {
    Map<String, dynamic>? nearestStation;
    double shortestDistance = double.infinity;

    for (final station in publicTransportStations) {
      final double stationLat = (station['lat'] as num).toDouble();
      final double stationLng = (station['lng'] as num).toDouble();

      final double distance = calculateDistanceKm(
        propertyLat,
        propertyLng,
        stationLat,
        stationLng,
      );

      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestStation = {
          ...station,
          'distanceKm': distance,
          'distanceText': '${distance.toStringAsFixed(2)} km',
        };
      }
    }

    return nearestStation ??
        {
          'name': 'Unknown',
          'type': '-',
          'distanceKm': 0.0,
          'distanceText': '-',
        };
  }

  @override
  void dispose() {
    searchController.dispose();
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final shownProperties = filteredProperties;
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF6F5A40);
    final Color searchBg = dark
        ? const Color(0xFF1E1E1E)
        : Colors.white.withOpacity(0.94);
    final Color cardShadow = dark
        ? Colors.black.withOpacity(0.20)
        : Colors.black.withOpacity(0.05);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        children: [
          Text(
            'Map Search',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find rental places in Kuala Lumpur with nearby public transport.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: secondaryText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: searchBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: cardShadow,
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: dark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.transparent,
              ),
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: TextStyle(color: dark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                icon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFFB17B30),
                ),
                hintText: 'Search by title or location',
                hintStyle: GoogleFonts.inter(
                  color: dark ? Colors.white54 : const Color(0xFF9A8B78),
                  fontSize: 13.5,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(
                const Color(0xFFE91E63),
                'Properties',
                labelColor: secondaryText,
              ),
              const SizedBox(width: 16),
              _legendDot(
                const Color(0xFF2196F3),
                'Public Transport',
                labelColor: secondaryText,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: dark
                      ? Colors.black.withOpacity(0.18)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: klCenter,
                  zoom: 11.5,
                ),
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markers: allMarkers,
                onMapCreated: (controller) {
                  mapController = controller;
                },
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: shownProperties.isEmpty
                ? Center(
                    child: Text(
                      'No properties found.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: shownProperties.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final property = shownProperties[index];
                      final bool isSelected =
                          selectedPropertyId == property['id'];

                      Map<String, dynamic>? nearest;
                      if (property['lat'] != null && property['lng'] != null) {
                        nearest = getNearestStation(
                          (property['lat'] as num).toDouble(),
                          (property['lng'] as num).toDouble(),
                        );
                      }

                      return GestureDetector(
                        onTap: () => moveToProperty(property),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (dark
                                      ? const Color(0xFF2A2A2A)
                                      : const Color(0xFFF3E8D7))
                                : (dark
                                      ? const Color(0xFF1E1E1E)
                                      : Colors.white.withOpacity(0.94)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFB17B30)
                                  : (dark
                                        ? Colors.white.withOpacity(0.06)
                                        : Colors.transparent),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: dark
                                          ? const Color(0xFF2A2A2A)
                                          : const Color(0xFFF8F1E7),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.location_on_rounded,
                                      color: Color(0xFFB17B30),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            color: dark
                                                ? Colors.white70
                                                : const Color(0xFF7B664C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    property['price'] ?? '',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: const Color(0xFFB17B30),
                                    ),
                                  ),
                                ],
                              ),
                              if (nearest != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: dark
                                        ? const Color(0xFF0F2238)
                                        : const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.train_rounded,
                                        size: 18,
                                        color: Color(0xFF2196F3),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Nearest transport: ${nearest['name']} (${nearest['distanceText']})',
                                          style: GoogleFonts.inter(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                            color: dark
                                                ? const Color(0xFF9DB7E8)
                                                : const Color(0xFF2B4A66),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label, {required Color labelColor}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}
