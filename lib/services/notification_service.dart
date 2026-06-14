import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final CollectionReference<Map<String, dynamic>> _notifications =
      FirebaseFirestore.instance.collection('notifications');

  Future<void> addNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
  }) async {
    await _notifications.add({
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserNotifications(
    String userId,
  ) {
    return _notifications
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> markAsRead(String notificationId) async {
    await _notifications.doc(notificationId).update({'isRead': true});
  }
}
