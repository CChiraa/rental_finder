import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_rental_app/services/property_service.dart';

class TenantMapTab extends StatefulWidget {
  const TenantMapTab({super.key});

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
      'location': 'Brickfields',
      'lat': 3.1343,
      'lng': 101.6861,
      'type': 'Transit Hub',
    },
    {
      'id': 'tbs',
      'name': 'Terminal Bersepadu Selatan (TBS)',
      'location': 'Bandar Tasik Selatan',
      'lat': 3.0764,
      'lng': 101.7116,
      'type': 'Bus Terminal',
    },
    {
      'id': 'puduraya',
      'name': 'Pudu Sentral',
      'location': 'City Centre',
      'lat': 3.1456,
      'lng': 101.6985,
      'type': 'Bus Terminal',
    },
    {
      'id': 'trx',
      'name': 'MRT TRX',
      'location': 'Tun Razak Exchange',
      'lat': 3.1428,
      'lng': 101.7191,
      'type': 'MRT',
    },
    {
      'id': 'cochrane',
      'name': 'MRT Cochrane',
      'location': 'Cochrane',
      'lat': 3.1329,
      'lng': 101.7227,
      'type': 'MRT',
    },
    {
      'id': 'maluri',
      'name': 'MRT Maluri',
      'location': 'Maluri',
      'lat': 3.1238,
      'lng': 101.7274,
      'type': 'MRT',
    },
    {
      'id': 'pasar_seni',
      'name': 'MRT Pasar Seni',
      'location': 'City Centre',
      'lat': 3.1424,
      'lng': 101.6953,
      'type': 'MRT',
    },
    {
      'id': 'muzium_negara',
      'name': 'MRT Muzium Negara',
      'location': 'KL Sentral',
      'lat': 3.1377,
      'lng': 101.6872,
      'type': 'MRT',
    },
    {
      'id': 'semantan',
      'name': 'MRT Semantan',
      'location': 'Damansara Heights',
      'lat': 3.1514,
      'lng': 101.6656,
      'type': 'MRT',
    },
    {
      'id': 'titiwangsa_mrt',
      'name': 'MRT Titiwangsa',
      'location': 'Titiwangsa',
      'lat': 3.1738,
      'lng': 101.6960,
      'type': 'MRT',
    },
    {
      'id': 'bukit_bintang_mrt',
      'name': 'MRT Bukit Bintang',
      'location': 'Bukit Bintang',
      'lat': 3.1469,
      'lng': 101.7113,
      'type': 'MRT',
    },
    {
      'id': 'masjid_jamek',
      'name': 'LRT Masjid Jamek',
      'location': 'Jalan Tun Perak',
      'lat': 3.1486,
      'lng': 101.6958,
      'type': 'LRT',
    },
    {
      'id': 'bandaraya',
      'name': 'LRT Bandaraya',
      'location': 'Jalan TAR',
      'lat': 3.1593,
      'lng': 101.6948,
      'type': 'LRT',
    },
    {
      'id': 'klcc',
      'name': 'LRT KLCC',
      'location': 'KLCC',
      'lat': 3.1578,
      'lng': 101.7123,
      'type': 'LRT',
    },
    {
      'id': 'dang_wangi',
      'name': 'LRT Dang Wangi',
      'location': 'Dang Wangi',
      'lat': 3.1561,
      'lng': 101.7015,
      'type': 'LRT',
    },
    {
      'id': 'universiti',
      'name': 'LRT Universiti',
      'location': 'University of Malaya',
      'lat': 3.1144,
      'lng': 101.6612,
      'type': 'LRT',
    },
    {
      'id': 'kerinchi',
      'name': 'LRT Kerinchi',
      'location': 'Bangsar South',
      'lat': 3.1116,
      'lng': 101.6676,
      'type': 'LRT',
    },
    {
      'id': 'abdullah_hukum',
      'name': 'LRT Abdullah Hukum',
      'location': 'Bangsar South',
      'lat': 3.1187,
      'lng': 101.6715,
      'type': 'LRT',
    },
    {
      'id': 'bukit_bintang_monorail',
      'name': 'Monorail Bukit Bintang',
      'location': 'Bukit Bintang',
      'lat': 3.1460,
      'lng': 101.7118,
      'type': 'Monorail',
    },
    {
      'id': 'imbi',
      'name': 'Monorail Imbi',
      'location': 'Imbi',
      'lat': 3.1421,
      'lng': 101.7114,
      'type': 'Monorail',
    },
    {
      'id': 'hang_tuah',
      'name': 'Monorail Hang Tuah',
      'location': 'Hang Tuah',
      'lat': 3.1407,
      'lng': 101.7071,
      'type': 'Monorail',
    },
    {
      'id': 'maharajalela',
      'name': 'Monorail Maharajalela',
      'location': 'Maharajalela',
      'lat': 3.1374,
      'lng': 101.7019,
      'type': 'Monorail',
    },
    {
      'id': 'chow_kit',
      'name': 'Monorail Chow Kit',
      'location': 'Chow Kit',
      'lat': 3.1663,
      'lng': 101.6974,
      'type': 'Monorail',
    },
    {
      'id': 'ktm_putra',
      'name': 'KTM Putra',
      'location': 'PWTC',
      'lat': 3.1662,
      'lng': 101.6925,
      'type': 'KTM',
    },
    {
      'id': 'ktm_bank_negara',
      'name': 'KTM Bank Negara',
      'location': 'Bank Negara',
      'lat': 3.1568,
      'lng': 101.6921,
      'type': 'KTM',
    },
    {
      'id': 'ktm_sentul',
      'name': 'KTM Sentul',
      'location': 'Sentul',
      'lat': 3.1747,
      'lng': 101.6869,
      'type': 'KTM',
    },
    {
      'id': 'ktm_mid_valley',
      'name': 'KTM Mid Valley',
      'location': 'Mid Valley',
      'lat': 3.1182,
      'lng': 101.6775,
      'type': 'KTM',
    },
    {
      'id': 'ktm_seputeh',
      'name': 'KTM Seputeh',
      'location': 'Seputeh',
      'lat': 3.1273,
      'lng': 101.6857,
      'type': 'KTM',
    },
    {
      'id': 'erl_klsentral',
      'name': 'ERL KL Sentral',
      'location': 'KL Sentral',
      'lat': 3.1343,
      'lng': 101.6861,
      'type': 'ERL',
    },
    {
      'id': 'erl_bts',
      'name': 'ERL Bandar Tasik Selatan',
      'location': 'Bandar Tasik Selatan',
      'lat': 3.0764,
      'lng': 101.7116,
      'type': 'ERL',
    },
  ];

  List<Map<String, dynamic>> _filterProperties(
    List<Map<String, dynamic>> properties,
  ) {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) return properties;

    return properties.where((property) {
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

  Set<Marker> _propertyMarkers(List<Map<String, dynamic>> properties) {
    return properties
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
      final String type = station['type'].toString();

      return Marker(
        markerId: MarkerId(station['id'].toString()),
        position: LatLng(
          (station['lat'] as num).toDouble(),
          (station['lng'] as num).toDouble(),
        ),
        infoWindow: InfoWindow(
          title: station['name'].toString(),
          snippet: '$type • ${station['location']}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          type.contains('Bus')
              ? BitmapDescriptor.hueOrange
              : type.contains('ERL')
              ? BitmapDescriptor.hueViolet
              : type.contains('KTM')
              ? BitmapDescriptor.hueGreen
              : BitmapDescriptor.hueAzure,
        ),
      );
    }).toSet();
  }

  Set<Marker> _allMarkers(List<Map<String, dynamic>> properties) {
    return {..._propertyMarkers(properties), ...transportMarkers};
  }

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

  void resetSelection() {
    setState(() {
      selectedPropertyId = null;
    });

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(target: klCenter, zoom: 11.5),
      ),
    );
  }

  void _openFullScreenMap(List<Map<String, dynamic>> properties) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenMapPage(
          markers: _allMarkers(properties),
          initialTarget: _selectedPropertyLatLng(properties) ?? klCenter,
        ),
      ),
    );
  }

  LatLng? _selectedPropertyLatLng(List<Map<String, dynamic>> properties) {
    if (selectedPropertyId == null) return null;

    final selected = properties.cast<Map<String, dynamic>?>().firstWhere(
      (property) => property?['id'] == selectedPropertyId,
      orElse: () => null,
    );

    if (selected == null ||
        selected['lat'] == null ||
        selected['lng'] == null) {
      return null;
    }

    return LatLng(
      (selected['lat'] as num).toDouble(),
      (selected['lng'] as num).toDouble(),
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
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF6F5A40);
    final Color searchBg = dark
        ? const Color(0xFF1E1E1E)
        : Colors.white.withOpacity(0.94);
    final Color cardShadow = dark
        ? Colors.black.withOpacity(0.20)
        : Colors.black.withOpacity(0.05);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: PropertyService().getPropertiesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load map properties',
              style: GoogleFonts.inter(color: secondaryText),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        final properties = docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id.hashCode;
          data['docId'] = doc.id;
          return data;
        }).toList();

        final shownProperties = _filterProperties(properties);
        final markers = _allMarkers(shownProperties);

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
                    'Rail',
                    labelColor: secondaryText,
                  ),
                  const SizedBox(width: 16),
                  _legendDot(Colors.orange, 'Bus', labelColor: secondaryText),
                ],
              ),
              const SizedBox(height: 14),
              Stack(
                children: [
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
                        markers: markers,
                        onMapCreated: (controller) {
                          mapController = controller;
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _openFullScreenMap(shownProperties),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: dark
                                ? Colors.black.withOpacity(0.65)
                                : Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.fullscreen_rounded,
                                size: 18,
                                color: Color(0xFFB17B30),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Full Screen',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: dark
                                      ? Colors.white
                                      : const Color(0xFF5E4B36),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                          final int propertyId = property['id'] ?? 0;
                          final bool isSelected =
                              selectedPropertyId == propertyId;

                          Map<String, dynamic>? nearest;
                          if (property['lat'] != null &&
                              property['lng'] != null) {
                            nearest = getNearestStation(
                              (property['lat'] as num).toDouble(),
                              (property['lng'] as num).toDouble(),
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              if (selectedPropertyId == propertyId) {
                                resetSelection();
                                return;
                              }

                              moveToProperty(property);
                            },
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
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
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
                                          Icon(
                                            nearest['type'].toString().contains(
                                                  'Bus',
                                                )
                                                ? Icons.directions_bus_rounded
                                                : nearest['type']
                                                      .toString()
                                                      .contains('ERL')
                                                ? Icons.airport_shuttle_rounded
                                                : nearest['type']
                                                      .toString()
                                                      .contains('KTM')
                                                ? Icons.tram_rounded
                                                : Icons.train_rounded,
                                            size: 18,
                                            color: const Color(0xFF2196F3),
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
      },
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

class FullScreenMapPage extends StatefulWidget {
  final Set<Marker> markers;
  final LatLng initialTarget;

  const FullScreenMapPage({
    super.key,
    required this.markers,
    required this.initialTarget,
  });

  @override
  State<FullScreenMapPage> createState() => _FullScreenMapPageState();
}

class _FullScreenMapPageState extends State<FullScreenMapPage> {
  GoogleMapController? fullMapController;

  @override
  void dispose() {
    fullMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialTarget,
              zoom: 13.5,
            ),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            mapToolbarEnabled: false,
            markers: widget.markers,
            onMapCreated: (controller) {
              fullMapController = controller;
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: dark
                          ? Colors.black.withOpacity(0.65)
                          : Colors.white.withOpacity(0.95),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: dark ? Colors.white : const Color(0xFF2B2118),
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
                      color: dark
                          ? Colors.black.withOpacity(0.65)
                          : Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Full Screen Map',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: dark ? Colors.white : const Color(0xFF5E4B36),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
