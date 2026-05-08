import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_rental_app/screens/welcome_screen.dart';
import 'package:smart_rental_app/screens/tenant/chat_detail_screen.dart';
import 'package:smart_rental_app/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void setDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  bool get currentThemeMode => isDarkMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Rental App',
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
