import 'package:dyota/firebase_options.dart';
import 'package:dyota/pages/Authentication/auth_page.dart';
import 'package:dyota/services/search_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Backfill searchTerms on existing products (no-op after first run)
  // Fire-and-forget so it doesn't block app startup
  SearchService().backfillSearchTerms();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
