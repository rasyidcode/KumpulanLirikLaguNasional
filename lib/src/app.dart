import 'package:flutter/material.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/about_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/detail_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/home_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/privacy_policy_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/splash_screen_page.dart';

class KumpulanLirikLaguKebangsaanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kumpulan Lirik Lagu Kebangsaan',
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: SplashScreenPage(),
    );
  }
}