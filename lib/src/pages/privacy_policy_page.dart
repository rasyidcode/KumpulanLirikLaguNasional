import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  WebViewController _controller;

  Future<Null> _loadLocalHtml() async {
    String fileText = await rootBundle.loadString('assets/privacy_policy.html');
    _controller.loadUrl(
      Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return WebView(
            initialUrl: '',
            onWebViewCreated: (WebViewController webviewController) {
              _controller = webviewController;
              _loadLocalHtml();
            },
          );
        },
      ),
    );
  }
}
