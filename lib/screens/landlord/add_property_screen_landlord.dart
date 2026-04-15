import 'package:flutter/material.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  String imagePath = 'images/bed1.jpg'; // dummy image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Property"),
        backgroundColor: const Color(0xFF0f2891),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Image Preview
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(imagePath, height: 150, fit: BoxFit.cover),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                // later can add image picker
              },
              child: const Text("Upload Image"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Property Title"),
            ),

            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),

            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
            ),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Property Added!")),
                );
                Navigator.pop(context);
              },
              child: const Text("Save Property"),
            ),
          ],
        ),
      ),
    );
  }
}
