import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trackrx/manufacturer/homepage.dart';

import 'AuthenticationPatient/splashscreen.dart';
import 'scannerpages/generateqr.dart';
import 'manufacturer/piechart.dart';
import 'scannerpages/scanqrcode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCjC09JvQcT61WlD3qx37xpTwrfwS2_-yc",
          appId: "1:782364550494: android:40ca73f7bc71efc9f21bcf",
          messagingSenderId: "782364550494",
          projectId: "trackrx-ea1da"));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true),
      routes: {
        "/generate": (context) => const GenerateQR(),
        "/scan": (context) => const ScanCodePage(),
      },
      home: SplashScreen(),
    );
  }
}
