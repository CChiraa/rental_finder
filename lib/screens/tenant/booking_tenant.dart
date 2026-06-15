import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_rental_app/services/booking_service.dart';
import 'package:smart_rental_app/services/storage_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookingSheet extends StatefulWidget {
  final Map<String, dynamic> property;

  const BookingSheet({super.key, required this.property});

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int guests = 1;

  final ImagePicker _picker = ImagePicker();
  final BookingService _bookingService = BookingService();
  final StorageService _storageService = StorageService();

  String paymentMethod = 'QR Payment';
  String? receiptPath;

  String get propertyId => (widget.property['docId'] ?? '').toString();

  String formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.day}/${date.month}/${date.year}';
  }

  int get totalNights {
    if (checkInDate == null || checkOutDate == null) return 0;
    return checkOutDate!.difference(checkInDate!).inDays;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    final parts = value.toString().split('/');

    if (parts.length == 3) {
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }

    return DateTime.now();
  }

  bool _isBlockedDate(DateTime date, List<BookingCalendarItem> bookings) {
    final selected = _dateOnly(date);

    for (final booking in bookings) {
      final status = booking.status.toLowerCase();

      if (status == 'rejected' ||
          status == 'cancelled' ||
          status == 'unsuccessful') {
        continue;
      }

      final start = _dateOnly(booking.from);
      final end = _dateOnly(booking.to);

      if ((selected.isAtSameMomentAs(start) || selected.isAfter(start)) &&
          selected.isBefore(end)) {
        return true;
      }
    }

    return false;
  }

  bool _rangeHasConflict(
    DateTime start,
    DateTime end,
    List<BookingCalendarItem> bookings,
  ) {
    for (final booking in bookings) {
      final status = booking.status.toLowerCase();

      if (status == 'rejected' ||
          status == 'cancelled' ||
          status == 'unsuccessful') {
        continue;
      }

      final existingStart = _dateOnly(booking.from);
      final existingEnd = _dateOnly(booking.to);

      final bool overlaps =
          start.isBefore(existingEnd) && end.isAfter(existingStart);
      if (overlaps) return true;
    }

    return false;
  }

  void _selectCalendarDate(
    DateTime selectedDate,
    List<BookingCalendarItem> bookings,
  ) {
    final date = _dateOnly(selectedDate);
    final today = _dateOnly(DateTime.now());

    if (date.isBefore(today)) {
      _showMessage('Please select today or a future date.');
      return;
    }

    if (_isBlockedDate(date, bookings)) {
      _showMessage('This date is already booked or pending approval.');
      return;
    }

    setState(() {
      if (checkInDate == null ||
          (checkInDate != null && checkOutDate != null) ||
          date.isBefore(checkInDate!)) {
        checkInDate = date;
        checkOutDate = null;
      } else if (date.isAfter(checkInDate!)) {
        if (_rangeHasConflict(checkInDate!, date, bookings)) {
          _showMessage('Selected range contains booked or pending dates.');
          return;
        }
        checkOutDate = date;
      } else {
        _showMessage('Check-out date must be after check-in date.');
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2B2118),
        content: Text(message, style: GoogleFonts.inter(color: Colors.white)),
      ),
    );
  }

  List<BookingCalendarItem> _mapBookings(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs.map((doc) {
      final data = doc.data();
      final status = (data['status'] ?? 'Pending').toString();

      return BookingCalendarItem(
        from: _parseDate(data['checkIn']),
        to: _parseDate(data['checkOut']),
        status: status,
        color: _statusColor(status),
      );
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'successful':
      case 'booked':
        return const Color(0xFF00A86B);
      case 'pending':
        return const Color(0xFFFF9800);
      case 'rejected':
      case 'cancelled':
      case 'unsuccessful':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFFC9A24A);
    }
  }

  Future<void> _submitBookingToFirestore() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    String receiptUrl = '';

    if (receiptPath != null && receiptPath!.isNotEmpty) {
      receiptUrl = await _storageService.uploadImage(
        folderName: 'payment_receipts/${user.uid}',
        filePath: receiptPath!,
      );
    }

    await _bookingService.addBooking(
      tenantId: user.uid,
      tenantName: user.displayName ?? user.email ?? 'Tenant',
      propertyId: propertyId,
      propertyTitle: widget.property['title'] ?? 'Property',
      landlordId: widget.property['landlordId'] ?? '',
      checkIn: formatDate(checkInDate),
      checkOut: formatDate(checkOutDate),
      guests: guests,
      paymentMethod: paymentMethod,
      receiptPath: receiptUrl,
    );
  }

  Future<void> _showPaymentSheet() async {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final String qrImage = (widget.property['qrImage'] ?? '').toString();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              decoration: BoxDecoration(
                color: dark ? const Color(0xFF121212) : const Color(0xFFF8F1E7),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: dark
                                ? Colors.white24
                                : Colors.brown.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'QR Payment',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: dark ? Colors.white : const Color(0xFF2B2118),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Scan the QR code and upload your payment receipt. Your booking will stay Pending until the landlord approves it.',
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          color: dark
                              ? Colors.white70
                              : const Color(0xFF7B664C),
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _softCard(
                        dark: dark,
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(
                                  0xFFD6B36A,
                                ).withOpacity(0.75),
                              ),
                            ),
                            child: qrImage.isNotEmpty
                                ? Image.network(
                                    qrImage,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) {
                                      return const SizedBox(
                                        height: 180,
                                        child: Center(
                                          child: Icon(
                                            Icons.qr_code_2_rounded,
                                            size: 90,
                                            color: Color(0xFFB17B30),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox(
                                    height: 180,
                                    child: Center(
                                      child: Icon(
                                        Icons.qr_code_2_rounded,
                                        size: 90,
                                        color: Color(0xFFB17B30),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _softCard(
                        dark: dark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload Receipt',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: dark
                                    ? Colors.white
                                    : const Color(0xFF2B2118),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () async {
                                final XFile? pickedFile = await _picker
                                    .pickImage(source: ImageSource.gallery);

                                if (pickedFile != null) {
                                  modalSetState(
                                    () => receiptPath = pickedFile.path,
                                  );
                                  setState(() => receiptPath = pickedFile.path);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: dark
                                      ? Colors.white.withOpacity(0.04)
                                      : const Color(0xFFF3E8D7),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFD6B36A,
                                    ).withOpacity(0.7),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.upload_file_rounded,
                                      size: 30,
                                      color: Color(0xFFB17B30),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      receiptPath == null
                                          ? 'Tap to upload receipt'
                                          : 'Receipt uploaded successfully',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: dark
                                            ? Colors.white70
                                            : const Color(0xFF7B664C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (receiptPath != null) ...[
                              const SizedBox(height: 14),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.file(
                                  File(receiptPath!),
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (receiptPath == null || receiptPath!.isEmpty) {
                              _showMessage(
                                'Please upload your payment receipt first.',
                              );
                              return;
                            }

                            try {
                              await _submitBookingToFirestore();

                              if (!mounted) return;
                              Navigator.pop(context);
                              Navigator.pop(context, true);
                            } catch (e) {
                              if (!mounted) return;
                              _showMessage('Failed to submit booking: $e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB17B30),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Submit Booking Request',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmBooking(List<BookingCalendarItem> bookings) async {
    if (checkInDate == null || checkOutDate == null) {
      _showMessage('Please select both check-in and check-out dates.');
      return;
    }

    if (!checkOutDate!.isAfter(checkInDate!)) {
      _showMessage('Check-out date must be after check-in date.');
      return;
    }

    if (_rangeHasConflict(checkInDate!, checkOutDate!, bookings)) {
      _showMessage('These dates are already booked or pending approval.');
      return;
    }

    await _showPaymentSheet();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _bookingService.getPropertyBookings(propertyId),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];
        final bookings = _mapBookings(docs);

        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF121212) : const Color(0xFFF8F1E7),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: dark
                              ? Colors.white24
                              : Colors.brown.withOpacity(0.20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Book ${widget.property['title']}',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: dark ? Colors.white : const Color(0xFF2B2118),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.property['location'] ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        color: dark ? Colors.white70 : const Color(0xFF7B664C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _legend(dark),
                    const SizedBox(height: 12),
                    _calendarCard(dark, bookings),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _dateCard(
                            dark: dark,
                            icon: Icons.login_rounded,
                            label: 'Check-in',
                            value: formatDate(checkInDate),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _dateCard(
                            dark: dark,
                            icon: Icons.logout_rounded,
                            label: 'Check-out',
                            value: formatDate(checkOutDate),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _softCard(
                      dark: dark,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Guests',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: dark
                                  ? Colors.white
                                  : const Color(0xFF2B2118),
                            ),
                          ),
                          Row(
                            children: [
                              _roundCounterButton(
                                dark: dark,
                                icon: Icons.remove_rounded,
                                onTap: () {
                                  if (guests > 1) setState(() => guests--);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                child: Text(
                                  '$guests',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: dark
                                        ? Colors.white
                                        : const Color(0xFF2B2118),
                                  ),
                                ),
                              ),
                              _roundCounterButton(
                                dark: dark,
                                icon: Icons.add_rounded,
                                onTap: () => setState(() => guests++),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _softCard(
                      dark: dark,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total nights',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: dark
                                  ? Colors.white
                                  : const Color(0xFF2B2118),
                            ),
                          ),
                          Text(
                            totalNights == 0 ? '-' : '$totalNights night(s)',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFB17B30),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _confirmBooking(bookings),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB17B30),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Confirm Booking',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _legend(bool dark) {
    return Row(
      children: [
        _legendItem('Available', const Color(0xFF00A86B), dark),
        const SizedBox(width: 10),
        _legendItem('Pending', const Color(0xFFFF9800), dark),
        const SizedBox(width: 10),
        _legendItem('Booked', const Color(0xFF00A86B), dark),
      ],
    );
  }

  Widget _legendItem(String label, Color color, bool dark) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: dark ? Colors.white70 : const Color(0xFF7B664C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendarCard(bool dark, List<BookingCalendarItem> bookings) {
    return Container(
      height: 360,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(24),
      ),
      child: SfCalendar(
        view: CalendarView.month,
        dataSource: BookingTenantDataSource(bookings),
        todayHighlightColor: const Color(0xFFB17B30),
        showNavigationArrow: true,
        onTap: (CalendarTapDetails details) {
          if (details.date != null) {
            _selectCalendarDate(details.date!, bookings);
          }
        },
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        ),
      ),
    );
  }

  Widget _dateCard({
    required bool dark,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return _softCard(
      dark: dark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFB17B30), size: 22),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: dark ? Colors.white : const Color(0xFF2B2118),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: dark ? Colors.white70 : const Color(0xFF7B664C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundCounterButton({
    required bool dark,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD6B36A).withOpacity(0.75)),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: const Color(0xFFB17B30), size: 18),
      ),
    );
  }

  Widget _softCard({required bool dark, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.65),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class BookingCalendarItem {
  final DateTime from;
  final DateTime to;
  final String status;
  final Color color;

  BookingCalendarItem({
    required this.from,
    required this.to,
    required this.status,
    required this.color,
  });
}

class BookingTenantDataSource extends CalendarDataSource {
  BookingTenantDataSource(List<BookingCalendarItem> source) {
    appointments = source;
  }

  BookingCalendarItem _booking(int index) =>
      appointments![index] as BookingCalendarItem;

  @override
  DateTime getStartTime(int index) {
    return _booking(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _booking(index).to;
  }

  @override
  String getSubject(int index) {
    return _booking(index).status;
  }

  @override
  Color getColor(int index) {
    return _booking(index).color;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }
}
