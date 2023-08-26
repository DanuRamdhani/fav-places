import 'package:fav_places/screen/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:fav_places/screen/auth.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 24, 18, 43),
  primary: const Color.fromARGB(255, 24, 18, 43),
  background: const Color.fromARGB(255, 50, 49, 66),
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  dialogTheme: DialogTheme(
    backgroundColor: colorScheme.background,
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor:
          MaterialStatePropertyAll(Color.fromARGB(255, 249, 249, 249)),
    ),
  ),
  datePickerTheme: const DatePickerThemeData(
    backgroundColor: Color.fromARGB(255, 180, 180, 180),
  ),
  textTheme: TextTheme(
    labelLarge: GoogleFonts.oswald(),
    bodyLarge: GoogleFonts.oswald(
      color: const Color.fromARGB(255, 250, 250, 250),  
    ),
    titleSmall: GoogleFonts.oswald(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.oswald(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.oswald(
      fontWeight: FontWeight.bold,
    ),
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fav Places',
      theme: theme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData) {
            return const VerifyEmailScreen();
          }

          return const AuthScreen();
        },
      ),
    );
  }
}
