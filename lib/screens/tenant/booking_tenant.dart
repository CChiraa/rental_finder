import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'booking_manager.dart';

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
  String paymentMethod = 'QR Payment';
  String? receiptPath;

  Future<void> selectDate(BuildContext context, bool isCheckIn) async {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final DateTime now = DateTime.now();

    final DateTime initialDate = isCheckIn
        ? (checkInDate ?? now)
        : (checkOutDate ??
              checkInDate?.add(const Duration(days: 1)) ??
              now.add(const Duration(days: 1)));

    final DateTime firstDate = isCheckIn
        ? now
        : (checkInDate ?? now).add(const Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: dark
                ? const ColorScheme.dark(
                    primary: Color(0xFFB17B30),
                    onPrimary: Colors.white,
                    surface: Color(0xFF1A1A1A),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Color(0xFFB17B30),
                    onPrimary: Colors.white,
                    surface: Color(0xFFF8F1E7),
                    onSurface: Color(0xFF2B2118),
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (checkOutDate != null && !checkOutDate!.isAfter(checkInDate!)) {
            checkOutDate = null;
          }
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.day}/${date.month}/${date.year}';
  }

  int get totalNights {
    if (checkInDate == null || checkOutDate == null) return 0;
    return checkOutDate!.difference(checkInDate!).inDays;
  }

  Future<void> _pickReceipt() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        receiptPath = pickedFile.path;
      });
    }
  }

  Future<void> _showPaymentSheet() async {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

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
                        'Scan the QR code below and upload your payment receipt.',
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          color: dark
                              ? Colors.white70
                              : const Color(0xFF7B664C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _softCard(
                        dark: dark,
                        child: Column(
                          children: [
                            Container(
                              height: 220,
                              width: 220,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(
                                    0xFFD6B36A,
                                  ).withOpacity(0.75),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/qr_payment.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.qr_code_2_rounded,
                                        size: 90,
                                        color: Color(0xFFB17B30),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              paymentMethod,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: dark
                                    ? Colors.white
                                    : const Color(0xFF2B2118),
                              ),
                            ),
                          ],
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
                                  modalSetState(() {
                                    receiptPath = pickedFile.path;
                                  });
                                  setState(() {
                                    receiptPath = pickedFile.path;
                                  });
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
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFF2B2118),
                                  content: Text(
                                    'Please upload your payment receipt first.',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }

                            final bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: dark
                                      ? const Color(0xFF1A1A1A)
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(
                                    'Confirm Booking',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      color: dark
                                          ? Colors.white
                                          : const Color(0xFF2B2118),
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to submit this booking and payment receipt?',
                                    style: GoogleFonts.inter(
                                      color: dark
                                          ? Colors.white70
                                          : const Color(0xFF5E4B36),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFFB17B30),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFB17B30,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Yes, Confirm',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              BookingManager.addBooking(
                                property: widget.property,
                                checkIn: formatDate(checkInDate),
                                checkOut: formatDate(checkOutDate),
                                paymentMethod: paymentMethod,
                                status: 'Pending',
                                receiptPath: receiptPath,
                              );

                              if (!mounted) return;

                              Navigator.pop(context);
                              Navigator.pop(context, true);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFFB17B30),
                                  content: Text(
                                    'Booking submitted successfully',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
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
                            'Confirm Payment',
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

  void _confirmBooking() async {
    if (checkInDate == null || checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF2B2118),
          content: Text(
            'Please select both check-in and check-out dates.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
        ),
      );
      return;
    }

    if (!checkOutDate!.isAfter(checkInDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF2B2118),
          content: Text(
            'Check-out date must be after check-in date.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
        ),
      );
      return;
    }

    await _showPaymentSheet();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF121212) : const Color(0xFFF8F1E7),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
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

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _dateCard(
                      dark: dark,
                      icon: Icons.calendar_today_rounded,
                      label: 'Check-in',
                      value: formatDate(checkInDate),
                      onTap: () => selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dateCard(
                      dark: dark,
                      icon: Icons.calendar_month_rounded,
                      label: 'Check-out',
                      value: formatDate(checkOutDate),
                      onTap: () => selectDate(context, false),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 4),
                        Text(
                          'Choose number of guests',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: dark
                                ? Colors.white70
                                : const Color(0xFF7B664C),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _roundCounterButton(
                          dark: dark,
                          icon: Icons.remove_rounded,
                          onTap: () {
                            if (guests > 1) {
                              setState(() => guests--);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
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
                          onTap: () {
                            setState(() => guests++);
                          },
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
                        color: dark ? Colors.white : const Color(0xFF2B2118),
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
                  onPressed: _confirmBooking,
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
    );
  }

  Widget _dateCard({
    required bool dark,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: _softCard(
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
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.16)
                : const Color(0xFFC89243).withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
