import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_rental_app/services/notification_service.dart';

class BookingService {
  final CollectionReference<Map<String, dynamic>> _bookings = FirebaseFirestore
      .instance
      .collection('bookings');

  final NotificationService _notificationService = NotificationService();

  Future<void> addBooking({
    required String tenantId,
    required String tenantName,
    required String propertyId,
    required String propertyTitle,
    required String landlordId,
    required String checkIn,
    required String checkOut,
    required int guests,
    required String paymentMethod,
    String receiptPath = '',
  }) async {
    await _bookings.add({
      'tenantId': tenantId,
      'tenantName': tenantName,
      'propertyId': propertyId,
      'propertyTitle': propertyTitle,
      'landlordId': landlordId,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'guests': guests,
      'paymentMethod': paymentMethod,
      'receiptPath': receiptPath,
      'status': 'Pending',
      'rejectionReason': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (landlordId.isNotEmpty) {
      await _notificationService.addNotification(
        userId: landlordId,
        title: 'New Booking Request',
        message:
            '$tenantName booked $propertyTitle. Please review the request.',
        type: 'booking_created',
      );
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTenantBookings(
    String tenantId,
  ) {
    return _bookings
        .where('tenantId', isEqualTo: tenantId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLandlordBookings(
    String landlordId,
  ) {
    return _bookings
        .where('landlordId', isEqualTo: landlordId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPropertyBookings(
    String propertyId,
  ) {
    return _bookings.where('propertyId', isEqualTo: propertyId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllBookings() {
    return _bookings.orderBy('createdAt', descending: true).snapshots();
  }

  Future<bool> hasDateConflict({
    required String propertyId,
    required String checkIn,
    required String checkOut,
  }) async {
    final snapshot = await _bookings
        .where('propertyId', isEqualTo: propertyId)
        .get();

    final DateTime newStart = _parseDate(checkIn);
    final DateTime newEnd = _parseDate(checkOut);

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final status = (data['status'] ?? '').toString().toLowerCase();

      if (status == 'rejected' ||
          status == 'cancelled' ||
          status == 'unsuccessful') {
        continue;
      }

      final DateTime existingStart = _parseDate(data['checkIn']);
      final DateTime existingEnd = _parseDate(data['checkOut']);

      final bool overlaps =
          newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart);

      if (overlaps) return true;
    }

    return false;
  }

  DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();

    final text = value.toString();
    final parts = text.split('/');

    if (parts.length == 3) {
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }

    return DateTime.now();
  }

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    await _bookings.doc(bookingId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePropertyAvailability({
    required String propertyId,
    required bool isAvailable,
  }) async {
    await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .update({
          'isAvailable': isAvailable,
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> approveBooking(String bookingId) async {
    final bookingDoc = await _bookings.doc(bookingId).get();

    if (!bookingDoc.exists || bookingDoc.data() == null) {
      throw Exception('Booking not found');
    }

    final bookingData = bookingDoc.data()!;
    final String propertyId = (bookingData['propertyId'] ?? '').toString();
    final String tenantId = (bookingData['tenantId'] ?? '').toString();
    final String propertyTitle =
        (bookingData['propertyTitle'] ?? 'your booking').toString();

    await _bookings.doc(bookingId).update({
      'status': 'Approved',
      'rejectionReason': '',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (propertyId.isNotEmpty) {
      await updatePropertyAvailability(
        propertyId: propertyId,
        isAvailable: false,
      );
    }

    if (tenantId.isNotEmpty) {
      await _notificationService.addNotification(
        userId: tenantId,
        title: 'Booking Approved',
        message: 'Your booking for $propertyTitle has been approved.',
        type: 'booking_approved',
      );
    }
  }

  Future<void> rejectBooking(
    String bookingId, {
    String rejectionReason = '',
  }) async {
    final bookingDoc = await _bookings.doc(bookingId).get();

    if (!bookingDoc.exists || bookingDoc.data() == null) {
      throw Exception('Booking not found');
    }

    final bookingData = bookingDoc.data()!;
    final String tenantId = (bookingData['tenantId'] ?? '').toString();
    final String propertyTitle =
        (bookingData['propertyTitle'] ?? 'your booking').toString();

    await _bookings.doc(bookingId).update({
      'status': 'Rejected',
      'rejectionReason': rejectionReason.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (tenantId.isNotEmpty) {
      await _notificationService.addNotification(
        userId: tenantId,
        title: 'Booking Rejected',
        message: rejectionReason.trim().isEmpty
            ? 'Your booking for $propertyTitle has been rejected.'
            : 'Your booking for $propertyTitle has been rejected. Reason: ${rejectionReason.trim()}',
        type: 'booking_rejected',
      );
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    await _bookings.doc(bookingId).delete();
  }
}
