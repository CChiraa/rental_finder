import 'package:flutter/material.dart';
import 'package:smart_rental_app/screens/welcome_screen.dart';
import 'package:smart_rental_app/theme/theme.dart';
import 'package:smart_rental_app/screens/tenant/chat_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightMode,
      home: const WelcomeScreen(),
      routes: {
        '/chatDetail': (context) {
          final chat =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return ChatDetailScreen(chat: chat);
        },
      },
    );
  }
}
