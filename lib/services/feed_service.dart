import 'package:cloud_firestore/cloud_firestore.dart';

class FeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> likeProperty({
    required String propertyId,
    required String userId,
  }) async {
    final likeRef = _firestore
        .collection('properties')
        .doc(propertyId)
        .collection('likes')
        .doc(userId);

    final likeDoc = await likeRef.get();

    if (likeDoc.exists) {
      await likeRef.delete();

      await _firestore.collection('properties').doc(propertyId).update({
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      await likeRef.set({'createdAt': FieldValue.serverTimestamp()});

      await _firestore.collection('properties').doc(propertyId).update({
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getComments(String propertyId) {
    return _firestore
        .collection('properties')
        .doc(propertyId)
        .collection('comments')
        .orderBy('createdAt')
        .snapshots();
  }

  Future<void> addComment({
    required String propertyId,
    required String userId,
    required String userName,
    required String comment,
  }) async {
    await _firestore
        .collection('properties')
        .doc(propertyId)
        .collection('comments')
        .add({
          'userId': userId,
          'userName': userName,
          'comment': comment,
          'createdAt': FieldValue.serverTimestamp(),
        });

    await _firestore.collection('properties').doc(propertyId).update({
      'commentsCount': FieldValue.increment(1),
    });
  }

  Future<void> incrementShare(String propertyId) async {
    await _firestore.collection('properties').doc(propertyId).update({
      'sharesCount': FieldValue.increment(1),
    });
  }
}
