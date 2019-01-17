
import 'package:flutter/material.dart';
import 'routes.dart';

class FinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Device Finder",
      home: handleCurrentScreen(),
      routes: routes,
    );
  }
}