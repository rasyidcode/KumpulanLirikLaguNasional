import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final db = Firestore.instance;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Timer(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/indo_flag.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            _buildSplashScreenWidget(),
            Column(
              children: <Widget>[
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: _isLoading ? CircularProgressIndicator() : Container(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSplashScreenWidget() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20.0)),
            child: Text(
              'Kumpulan Lirik Lagu Nasional',
              style: TextStyle(fontSize: 21.0, color: Colors.white),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Copyright @ 2019',
            style: TextStyle(color: Colors.black54, fontSize: 12.0),
          )
        ],
      ),
    );
  }
}
