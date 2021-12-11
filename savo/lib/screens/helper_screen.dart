import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/screens/home.dart';
import 'package:main/screens/login_screen.dart';

class HelperScreen extends StatelessWidget {
  static const routeName = '/';
  const HelperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      });
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, Home.routeName);
      });
    }
    return SizedBox();
  }
}
