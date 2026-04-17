class BookingManager {
  static final List<Map<String, dynamic>> bookings = [];

  static void addBooking({
    required Map<String, dynamic> property,
    required String checkIn,
    required String checkOut,
    required String paymentMethod,
    String status = 'Pending',
    String? receiptPath,
  }) {
    bookings.insert(0, {
      'bookingId': DateTime.now().millisecondsSinceEpoch.toString(),
      'propertyId': property['id'] ?? 0,
      'title': property['title'] ?? 'Property',
      'location': property['location'] ?? '',
      'price': property['price'] ?? '',
      'image': property['image'] ?? '',
      'checkIn': checkIn,
      'checkOut': checkOut,
      'paymentMethod': paymentMethod,
      'paymentStatus': status,
      'bookingStatus': status == 'Successful' ? 'Confirmed' : 'Pending',
      'receiptPath': receiptPath ?? '',
      'createdAt': DateTime.now().toString(),
    });
  }

  static void updateBookingStatus({
    required String bookingId,
    required String paymentStatus,
    String? receiptPath,
  }) {
    final index = bookings.indexWhere((item) => item['bookingId'] == bookingId);
    if (index == -1) return;

    bookings[index]['paymentStatus'] = paymentStatus;
    bookings[index]['bookingStatus'] = paymentStatus == 'Successful'
        ? 'Confirmed'
        : 'Pending';

    if (receiptPath != null) {
      bookings[index]['receiptPath'] = receiptPath;
    }
  }

  static List<Map<String, dynamic>> get paymentHistory => bookings;
}
