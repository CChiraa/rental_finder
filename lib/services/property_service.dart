import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyService {
  final CollectionReference<Map<String, dynamic>> _properties =
      FirebaseFirestore.instance.collection('properties');

  Future<void> addProperty({
    required String title,
    required String location,
    required String price,
    required String description,
    required String type,
    required String stayCategory,
    required double lat,
    required double lng,
    required String landlordId,
    required String landlordName,
    List<String> images = const [],
    String qrImage = '',
  }) async {
    await _properties.add({
      'title': title.trim(),
      'location': location.trim(),
      'price': price.trim(),
      'description': description.trim(),
      'type': type.trim(),
      'stayCategory': stayCategory.trim(),
      'lat': lat,
      'lng': lng,
      'landlordId': landlordId,
      'landlordName': landlordName.trim(),
      'images': images,
      'qrImage': qrImage,

      // Feed & engagement
      'likesCount': 0,
      'commentsCount': 0,
      'sharesCount': 0,

      // Property status
      'isAvailable': true,

      // Timestamps
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPropertiesStream() {
    return _properties.orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLandlordPropertiesStream(
    String landlordId,
  ) {
    return _properties
        .where('landlordId', isEqualTo: landlordId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPropertyById(
    String propertyId,
  ) async {
    return _properties.doc(propertyId).get();
  }

  Future<void> updateProperty({
    required String propertyId,
    required Map<String, dynamic> data,
  }) async {
    await _properties.doc(propertyId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePropertyAvailability({
    required String propertyId,
    required bool isAvailable,
  }) async {
    await _properties.doc(propertyId).update({
      'isAvailable': isAvailable,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> incrementLikes(String propertyId) async {
    await _properties.doc(propertyId).update({
      'likesCount': FieldValue.increment(1),
    });
  }

  Future<void> decrementLikes(String propertyId) async {
    await _properties.doc(propertyId).update({
      'likesCount': FieldValue.increment(-1),
    });
  }

  Future<void> incrementComments(String propertyId) async {
    await _properties.doc(propertyId).update({
      'commentsCount': FieldValue.increment(1),
    });
  }

  Future<void> deleteProperty(String propertyId) async {
    await _properties.doc(propertyId).delete();
  }
}
