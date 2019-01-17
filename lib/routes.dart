import 'package:device_finder/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/home.dart';
import './screens/login.dart';
import './screens/splash.dart';

var routes = <String, WidgetBuilder>{
  "/HomePage": (BuildContext context) => HomePage(),
  "/LoginPage": (BuildContext context) => LoginPage()
};

Widget handleCurrentScreen() {
  return new StreamBuilder<FirebaseUser>(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SplashScreen();
      } else {
        if (snapshot.hasData) {
          return HomePage();
        }
        return LoginPage();
      }
    }
  );
}