import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class LandlordAvailabilityTab extends StatefulWidget {
  final bool dark;
  final Color glassCard;
  final Color glassBorder;

  const LandlordAvailabilityTab({
    super.key,
    required this.dark,
    required this.glassCard,
    required this.glassBorder,
  });

  @override
  State<LandlordAvailabilityTab> createState() =>
      _LandlordAvailabilityTabState();
}

class _LandlordAvailabilityTabState extends State<LandlordAvailabilityTab> {
  CalendarView _calendarView = CalendarView.month;
  String _selectedProperty = 'All Properties';
  DateTime _selectedDate = DateTime.now();

  final List<String> _propertyOptions = const [
    'All Properties',
    'Condo near KLCC',
    'Studio Apartment',
    'Cozy Family House',
  ];

  final List<PropertyBooking> _allBookings = [
    PropertyBooking(
      propertyName: 'Condo near KLCC',
      title: 'Booked',
      from: DateTime(2026, 4, 24, 14, 0),
      to: DateTime(2026, 4, 26, 12, 0),
      color: const Color(0xFFC9A24A),
      status: 'Booked',
      guestName: 'Aina',
    ),
    PropertyBooking(
      propertyName: 'Studio Apartment',
      title: 'Pending',
      from: DateTime(2026, 4, 28, 10, 0),
      to: DateTime(2026, 4, 28, 18, 0),
      color: const Color(0xFFFF9800),
      status: 'Pending',
      guestName: 'Daniel',
    ),
    PropertyBooking(
      propertyName: 'Cozy Family House',
      title: 'Booked',
      from: DateTime(2026, 4, 30, 15, 0),
      to: DateTime(2026, 5, 2, 11, 0),
      color: const Color(0xFFC9A24A),
      status: 'Booked',
      guestName: 'Sara',
    ),
    PropertyBooking(
      propertyName: 'Condo near KLCC',
      title: 'Blocked',
      from: DateTime(2026, 5, 6, 0, 0),
      to: DateTime(2026, 5, 8, 23, 59),
      color: const Color(0xFFE53935),
      status: 'Blocked',
      guestName: 'Blocked',
    ),
  ];

  List<PropertyBooking> get _filteredBookings {
    if (_selectedProperty == 'All Properties') {
      return _allBookings;
    }
    return _allBookings
        .where((booking) => booking.propertyName == _selectedProperty)
        .toList();
  }

  List<PropertyBooking> get _selectedDayBookings {
    final start = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      0,
      0,
      0,
    );
    final end = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      23,
      59,
      59,
    );

    return _filteredBookings.where((booking) {
      return booking.from.isBefore(end) && booking.to.isAfter(start);
    }).toList();
  }

  int get _bookedCount =>
      _filteredBookings.where((b) => b.status == 'Booked').length;

  int get _pendingCount =>
      _filteredBookings.where((b) => b.status == 'Pending').length;

  int get _blockedCount =>
      _filteredBookings.where((b) => b.status == 'Blocked').length;

  int get _availableCount {
    const totalProperties = 12;
    final unavailable = _filteredBookings
        .map((e) => e.propertyName)
        .toSet()
        .length;
    final value = totalProperties - unavailable;
    return value < 0 ? 0 : value;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = widget.dark
        ? Colors.white70
        : const Color(0xFF7B6243);
    final Color goldText = widget.dark
        ? const Color(0xFFE6BC6D)
        : const Color(0xFFC9A24A);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Place Availability",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "View property availability, bookings and pending requests using a real calendar.",
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: secondaryText,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          _buildOverviewSection(
            primaryText: primaryText,
            secondaryText: secondaryText,
          ),

          const SizedBox(height: 22),

          _buildSectionTitle(
            title: "Property Filter",
            actionText: "Select",
            primaryText: primaryText,
            actionColor: goldText,
          ),
          const SizedBox(height: 12),

          _buildPropertyDropdown(primaryText),

          const SizedBox(height: 22),

          _buildSectionTitle(
            title: "View Mode",
            actionText: _viewLabel(_calendarView),
            primaryText: primaryText,
            actionColor: goldText,
          ),
          const SizedBox(height: 12),

          _buildViewModeSelector(),

          const SizedBox(height: 22),

          _buildSectionTitle(
            title: "Calendar",
            actionText: "Interactive",
            primaryText: primaryText,
            actionColor: goldText,
          ),
          const SizedBox(height: 12),

          _buildCalendarCard(primaryText, secondaryText),

          const SizedBox(height: 22),

          _buildSectionTitle(
            title: "Selected Date",
            actionText:
                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
            primaryText: primaryText,
            actionColor: goldText,
          ),
          const SizedBox(height: 12),

          _buildSelectedDatePanel(
            primaryText: primaryText,
            secondaryText: secondaryText,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection({
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.52),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: widget.dark
              ? Colors.white.withOpacity(0.10)
              : const Color(0xFFD6BC91).withOpacity(0.8),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.dark
                ? Colors.black.withOpacity(0.16)
                : const Color(0xFFD8AF5B).withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title: "Overview", primaryText: primaryText),
          const SizedBox(height: 8),
          Text(
            "Quick snapshot of current booking status",
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  title: "Available",
                  value: _availableCount.toString(),
                  icon: Icons.event_available_rounded,
                  color: const Color(0xFF00A86B),
                  dark: widget.dark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  title: "Booked",
                  value: _bookedCount.toString(),
                  icon: Icons.calendar_month_rounded,
                  color: const Color(0xFFC9A24A),
                  dark: widget.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  title: "Pending",
                  value: _pendingCount.toString(),
                  icon: Icons.hourglass_top_rounded,
                  color: const Color(0xFFFF9800),
                  dark: widget.dark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  title: "Blocked",
                  value: _blockedCount.toString(),
                  icon: Icons.block_rounded,
                  color: const Color(0xFFE53935),
                  dark: widget.dark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDropdown(Color primaryText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: widget.glassCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: widget.glassBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedProperty,
          isExpanded: true,
          dropdownColor: widget.dark ? const Color(0xFF1A2236) : Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: primaryText,
          ),
          items: _propertyOptions
              .map(
                (property) => DropdownMenuItem<String>(
                  value: property,
                  child: Text(property),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _selectedProperty = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildViewModeSelector() {
    return Row(
      children: [
        Expanded(
          child: _viewChip(
            title: "Month",
            selected: _calendarView == CalendarView.month,
            onTap: () => setState(() => _calendarView = CalendarView.month),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _viewChip(
            title: "Week",
            selected: _calendarView == CalendarView.week,
            onTap: () => setState(() => _calendarView = CalendarView.week),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _viewChip(
            title: "Schedule",
            selected: _calendarView == CalendarView.schedule,
            onTap: () => setState(() => _calendarView = CalendarView.schedule),
          ),
        ),
      ],
    );
  }

  Widget _viewChip({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFC9A24A).withOpacity(0.18)
                : widget.glassCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? const Color(0xFFC9A24A).withOpacity(0.45)
                  : widget.glassBorder,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: selected
                    ? const Color(0xFFC9A24A)
                    : (widget.dark ? Colors.white70 : const Color(0xFF7B6243)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard(Color primaryText, Color secondaryText) {
    return Container(
      width: double.infinity,
      height: _calendarView == CalendarView.schedule ? 500 : 430,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: widget.dark
            ? Colors.white.withOpacity(0.06)
            : Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: widget.dark
              ? Colors.white.withOpacity(0.10)
              : const Color(0xFFE8DCC8),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.dark
                ? Colors.black.withOpacity(0.18)
                : const Color(0xFFD8AF5B).withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: SfCalendar(
          view: _calendarView,
          firstDayOfWeek: 1,
          dataSource: BookingDataSource(_filteredBookings),
          backgroundColor: Colors.transparent,
          showNavigationArrow: true,
          todayHighlightColor: const Color(0xFFC9A24A),
          cellBorderColor: Colors.transparent,
          selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: const Color(0xFFC9A24A), width: 1.8),
            borderRadius: BorderRadius.circular(12),
          ),
          headerHeight: 56,
          viewHeaderHeight: 36,
          headerStyle: CalendarHeaderStyle(
            backgroundColor: Colors.transparent,
            textAlign: TextAlign.center,
            textStyle: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          viewHeaderStyle: ViewHeaderStyle(
            backgroundColor: Colors.transparent,
            dayTextStyle: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: secondaryText.withOpacity(0.85),
              letterSpacing: 0.8,
            ),
            dateTextStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: secondaryText,
            ),
          ),
          monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            showAgenda: true,
            monthCellStyle: MonthCellStyle(
              backgroundColor: Colors.transparent,
              todayBackgroundColor: const Color(0xFFF3E4BE),
              trailingDatesBackgroundColor: Colors.transparent,
              leadingDatesBackgroundColor: Colors.transparent,
              textStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
              todayTextStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF8E6A39),
              ),
              trailingDatesTextStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: secondaryText.withOpacity(0.38),
              ),
              leadingDatesTextStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: secondaryText.withOpacity(0.38),
              ),
            ),
            agendaStyle: AgendaStyle(
              backgroundColor: Colors.transparent,
              appointmentTextStyle: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
              dateTextStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
              dayTextStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: secondaryText,
              ),
            ),
          ),
          appointmentTextStyle: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 8,
            endHour: 22,
            timeIntervalHeight: 62,
            timeTextStyle: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: secondaryText,
            ),
            dayFormat: 'EEE',
            dateFormat: 'd',
          ),
          onSelectionChanged: (CalendarSelectionDetails details) {
            if (details.date != null) {
              setState(() {
                _selectedDate = details.date!;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildSelectedDatePanel({
    required Color primaryText,
    required Color secondaryText,
  }) {
    final items = _selectedDayBookings;

    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: widget.glassCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: widget.glassBorder),
        ),
        child: Text(
          "No bookings on this date. This day is available.",
          style: GoogleFonts.inter(
            fontSize: 13.2,
            fontWeight: FontWeight.w600,
            color: primaryText,
          ),
        ),
      );
    }

    return Column(
      children: items.map((booking) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.glassCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: widget.glassBorder),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: booking.color.withOpacity(0.12),
                child: Icon(_statusIcon(booking.status), color: booking.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.propertyName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Guest: ${booking.guestName}",
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${booking.from.day}/${booking.from.month} - ${booking.to.day}/${booking.to.month}",
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: booking.color,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: booking.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  booking.status,
                  style: GoogleFonts.inter(
                    fontSize: 11.8,
                    fontWeight: FontWeight.w700,
                    color: booking.color,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required Color primaryText,
    String? actionText,
    Color? actionColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        if (actionText != null && actionText.trim().isNotEmpty)
          Text(
            actionText,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: actionColor ?? const Color(0xFFC9A24A),
            ),
          ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool dark,
  }) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.42),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.08)
              : const Color(0xFFD9BC8A).withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: dark ? Colors.white : const Color(0xFF1D1D1F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12.6,
                    fontWeight: FontWeight.w500,
                    color: dark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _viewLabel(CalendarView view) {
    switch (view) {
      case CalendarView.month:
        return "Month";
      case CalendarView.week:
        return "Week";
      case CalendarView.schedule:
        return "Schedule";
      default:
        return "Calendar";
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Booked':
        return Icons.calendar_month_rounded;
      case 'Pending':
        return Icons.hourglass_top_rounded;
      case 'Blocked':
        return Icons.block_rounded;
      default:
        return Icons.event_available_rounded;
    }
  }
}

class PropertyBooking {
  final String propertyName;
  final String title;
  final DateTime from;
  final DateTime to;
  final Color color;
  final String status;
  final String guestName;

  PropertyBooking({
    required this.propertyName,
    required this.title,
    required this.from,
    required this.to,
    required this.color,
    required this.status,
    required this.guestName,
  });
}

class BookingDataSource extends CalendarDataSource {
  BookingDataSource(List<PropertyBooking> source) {
    appointments = source;
  }

  PropertyBooking _booking(int index) =>
      appointments![index] as PropertyBooking;

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
    return _booking(index).title;
  }

  @override
  Color getColor(int index) {
    return _booking(index).color;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
