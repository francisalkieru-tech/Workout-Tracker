import 'package:flutter/material.dart';
import 'frontpage.dart';
import 'personalPage.dart';
import 'userlog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase already ensureInitialized
  }

  runApp(const ExerciseApp());
}

class ExerciseApp extends StatelessWidget {
  const ExerciseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise App',
      theme: ThemeData.dark(),
      scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
      initialRoute: '/Front',
      routes: {
        '/signup': (context) => const UserLog(),
        '/Personal': (context) => Personalize(),
        '/Front': (context) => const FrontPage(),
      },
    );
  }
}
