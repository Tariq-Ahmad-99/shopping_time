import 'dart:core';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewScreen extends StatelessWidget {

  late final WebViewController controller;

  final String? url;

  WebViewScreen(this.url, {super.key} ) {
    controller = WebViewController()
    ..loadRequest(Uri.parse(url!));
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
          controller: controller,
      ),
    );
  }
}