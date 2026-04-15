import 'package:flutter/material.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Earnings"),
        backgroundColor: const Color(0xFF0f2891),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Card(
              child: ListTile(
                title: Text("Total Earnings"),
                trailing: Text("RM 1,240"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("This Month"),
                trailing: Text("RM 620"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
