import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color(0xFF0f2891),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("New Booking Received"),
            subtitle: Text("Your condo has been booked"),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Payment Received"),
            subtitle: Text("RM178 credited to your account"),
          ),
        ],
      ),
    );
  }
}
