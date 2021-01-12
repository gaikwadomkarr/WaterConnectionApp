import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterconnection/Helpers/SessionData.dart';
import 'package:waterconnection/UI/HomePage.dart';
import 'package:waterconnection/UI/LoginScreen.dart';
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loggedin = false;
  @override
  void initState() {
    super.initState();
    getloggedin();
  }

  void getloggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedin = prefs.getBool("loggedin") ?? false;
    if (loggedin) {
      SessionData.fromJson(json.decode(prefs.getString("SESSION_DATA")));
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: Image.asset(
              "assets/AppLogo.jpg",
              height: 150,
            ),
          ),
        ),
      ),
    );
  }
}
