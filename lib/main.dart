 import 'package:SoundSphere/screens/home.dart';
import 'package:SoundSphere/screens/login/email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
  runApp(const SoundSphere());
}

class SoundSphere extends StatelessWidget {
  const SoundSphere({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget nextPage = FirebaseAuth.instance.currentUser == null ? const LoginEmail() : const Home();
    return MaterialApp(
      title: "SoundSphere",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF02203A),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor: MaterialStateColor.resolveWith((states) => Colors.white)
          )
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF86C9),
          foregroundColor: Color(0xFF02203A),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 30,),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
        dialogTheme: const DialogTheme(backgroundColor: Color(0xFF02203A),)
      ),
      debugShowCheckedModeBanner: false,
      home: nextPage,
    );
  }
}
