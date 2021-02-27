import 'package:flutter/material.dart';
import 'SignIn1.dart';
import 'SignUp1.dart';

class Authenticate1 extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate1> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn1(toggleView);
    } else {
      return SignUp2(toggleView);
    }
  }
}
