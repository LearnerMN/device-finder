import 'package:device_finder/api.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LoginPage extends StatelessWidget {

  Future<bool> _loginUser() async {
    final api = await FBApi.signInWithGoogle();
    return api != null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                SizedBox(height: 16.0),
                Text('Device Finder'),
              ],
            ),
            SizedBox(height: 140.0),
            MaterialButton(
              child: const Text('SIGN IN WITH GOOGLE'),
              onPressed: () async{
                bool logged = await _loginUser();
                logged ? Navigator.of(context).pushReplacementNamed('/HomePage')
                  : Scaffold.of(context).showSnackBar(SnackBar(content: Text('Wrong Email!')));
              }
            )
          ],
        ),
      ),
    );
  }
}
