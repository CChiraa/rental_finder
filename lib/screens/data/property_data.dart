class PropertyRepository {
  static final List<Map<String, dynamic>> properties = [
    {
      'id': 1,
      'title': 'Luxury Condo',
      'location': 'KLCC, Kuala Lumpur',
      'price': 'RM178/night',
      'image': 'images/bed3.jpg',
      'description':
          'A modern luxury condominium located in the heart of Kuala Lumpur, just minutes away from KLCC. Fully furnished with high-speed WiFi, swimming pool, gym, and 24-hour security.',
      'lat': 3.1579,
      'lng': 101.7123,
      'postedBy': 'Alya Property',
      'type': 'Condo',
    },
    {
      'id': 2,
      'title': 'Modern Apartment',
      'location': 'Bukit Bintang, Kuala Lumpur',
      'price': 'RM200/night',
      'image': 'images/bed1.jpg',
      'description':
          'Stylish apartment located in Bukit Bintang, surrounded by shopping malls, cafes, and nightlife.',
      'lat': 3.1466,
      'lng': 101.7113,
      'postedBy': 'Urban Stay',
      'type': 'Apartment',
    },
    {
      'id': 3,
      'title': 'Family House',
      'location': 'Damansara, Selangor',
      'price': 'RM350/night',
      'image': 'images/liv1.jpg',
      'description':
          'Spacious landed house ideal for families. Features 3 bedrooms, large living area, private parking, and a peaceful neighborhood.',
      'lat': 3.1490,
      'lng': 101.6169,
      'postedBy': 'Damansara Homes',
      'type': 'House',
    },
  ];

  static List<Map<String, dynamic>> getAllProperties() {
    return List<Map<String, dynamic>>.from(properties);
  }

  static void addProperty(Map<String, dynamic> property) {
    properties.insert(0, property);
  }

  static void updateProperty(int id, Map<String, dynamic> updatedProperty) {
    final index = properties.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      properties[index] = updatedProperty;
    }
  }

  static void deleteProperty(int id) {
    properties.removeWhere((item) => item['id'] == id);
  }
}
