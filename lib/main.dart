import 'package:SoundSphere/screens/home.dart';
import 'package:SoundSphere/screens/login_email/login_email.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const SoundSphere());
}

class SoundSphere extends StatelessWidget {
  const SoundSphere({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "SoundSphere",
      color: Color(0xFF02203A),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
