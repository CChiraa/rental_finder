import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Future<void> selectDate(BuildContext context, bool isCheckIn) async {
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
            colorScheme: const ColorScheme.light(
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: Color(0xFFF8F1E7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                    color: Colors.brown.withOpacity(0.20),
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
                  color: const Color(0xFF2B2118),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                widget.property['location'] ?? '',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: const Color(0xFF7B664C),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _dateCard(
                      icon: Icons.calendar_today_rounded,
                      label: 'Check-in',
                      value: formatDate(checkInDate),
                      onTap: () => selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dateCard(
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
                            color: const Color(0xFF2B2118),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Choose number of guests',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: const Color(0xFF7B664C),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _roundCounterButton(
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
                              color: const Color(0xFF2B2118),
                            ),
                          ),
                        ),
                        _roundCounterButton(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total nights',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2B2118),
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
                  onPressed: () {
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

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF2B2118),
                        content: Text(
                          'Booking confirmed for ${widget.property['title']} • $guests guest(s) • $totalNights night(s)',
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                      ),
                    );
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
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: _softCard(
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
                color: const Color(0xFF2B2118),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF7B664C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundCounterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD6B36A).withOpacity(0.75)),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: const Color(0xFFB17B30), size: 18),
      ),
    );
  }

  Widget _softCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.65), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC89243).withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
