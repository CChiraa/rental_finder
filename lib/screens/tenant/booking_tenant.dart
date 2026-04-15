import 'package:flutter/material.dart';

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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book ${widget.property['title']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                checkInDate == null
                    ? 'Select Check-in Date'
                    : 'Check-in: ${checkInDate!.toString().split(' ')[0]}',
              ),
              onTap: () => selectDate(context, true),
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(
                checkOutDate == null
                    ? 'Select Check-out Date'
                    : 'Check-out: ${checkOutDate!.toString().split(' ')[0]}',
              ),
              onTap: () => selectDate(context, false),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Guests'),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (guests > 1) setState(() => guests--);
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$guests'),
                    IconButton(
                      onPressed: () {
                        setState(() => guests++);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (checkInDate == null || checkOutDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select dates')),
                    );
                    return;
                  }

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Booking Confirmed for ${widget.property['title']} ($guests guest)',
                      ),
                    ),
                  );
                },
                child: const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
