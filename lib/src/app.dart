import 'package:flutter/material.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/splash_screen_page.dart';

class KumpulanLirikLaguKebangsaanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kumpulan Lirik Lagu Kebangsaan',
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.redAccent,
        fontFamily: 'Ubuntu'
      ),
      home: SplashScreenPage(),
    );
  }
}