import 'package:flutter/material.dart';

class BookingManagementScreen extends StatelessWidget {
  const BookingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookings"),
        backgroundColor: const Color(0xFF0f2891),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Condo near KLCC"),
            subtitle: Text("John - 12 Aug to 15 Aug"),
            trailing: Text("RM500"),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Studio Apartment"),
            subtitle: Text("Ali - 20 Aug to 22 Aug"),
            trailing: Text("RM240"),
          ),
        ],
      ),
    );
  }
}
