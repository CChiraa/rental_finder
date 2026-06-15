import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPromotionService {
  final CollectionReference<Map<String, dynamic>> _feeds = FirebaseFirestore
      .instance
      .collection('feeds');

  Future<void> addFeedPromotion({
    required String landlordId,
    required String landlordName,
    required String title,
    required String propertyName,
    required String tag,
    required String caption,
    required String details,
    required String discount,
    required String imageUrl,
  }) async {
    await _feeds.add({
      'landlordId': landlordId,
      'landlordName': landlordName,
      'title': title.trim(),
      'propertyName': propertyName.trim(),
      'tag': tag.trim(),
      'caption': caption.trim(),
      'details': details.trim(),
      'discount': discount.trim(),
      'imageUrl': imageUrl,
      'likesCount': 0,
      'commentsCount': 0,
      'sharesCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFeedPromotions() {
    return _feeds.orderBy('createdAt', descending: true).snapshots();
  }
}
