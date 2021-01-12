import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterconnection/Helpers/FlavConfig.dart';
import 'package:waterconnection/Helpers/NetworkHelprs.dart';
import 'package:waterconnection/Helpers/SessionData.dart';
import 'package:waterconnection/UI/HomePage.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool obscure = true;
  SharedPreferences prefs;
  bool isLoggingin = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoggingin,
      child: WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
            child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.white,
                body: Form(
                  key: _formKey,
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      margin: EdgeInsets.all(30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/AppLogo.jpg",
                              height: 150,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            buildTextFormField(
                                username,
                                false,
                                Icon(Icons.person, color: Colors.black),
                                null,
                                "Username *"),
                            SizedBox(
                              height: 20,
                            ),
                            buildTextFormField(
                                password,
                                obscure,
                                Icon(Icons.lock, color: Colors.black),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscure = !obscure;
                                    });
                                  },
                                  child: obscure
                                      ? Icon(
                                          Icons.visibility,
                                          color: Colors.black,
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          color: Colors.black,
                                        ),
                                ),
                                "Password *"),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {
                                hitLoginApi();
                              },
                              color: Colors.black,
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    letterSpacing: 2),
                              ),
                            )
                          ]),
                    ),
                  ),
                ))),
      ),
    );
  }

  Container buildTextFormField(TextEditingController controller,
      bool obscureText, Icon prefixIcon, Widget suffixIcon, String labelText) {
    return Container(
      child: TextFormField(
          autocorrect: false,
          controller: controller,
          obscureText: obscureText,
          validator: (text) {
            if (text.isEmpty) {
              if (controller == username) {
                return "Username cannot be empty";
              } else {
                return "Password cannot be empty";
              }
            }
            return null;
          },
          decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: Colors.black, width: 0.9),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              focusedBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Colors.black, width: 0.9),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.black)),
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.black54))),
    );
  }

  void hitLoginApi() async {
    Dio dio = new Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';

    setState(() {
      isLoggingin = true;
    });
    if (_formKey.currentState.validate()) {
      String url = FlavorConfig.instance.url() + "/Login/verify";
      print("this is login url => " + url);
      prefs = await SharedPreferences.getInstance();
      FormData formData = FormData.fromMap(
          {"username": username.text, "password": password.text});
      print(formData.fields);
      try {
        await dio
            .post(
          url,
          data: formData,
        )
            .then((response) {
          print(response.statusCode);
          print(response.data);
          if (response.statusCode == 200) {
            setState(() {
              isLoggingin = false;
            });
            SessionData.fromJson(response.data);
            prefs.setBool("loggedin", true);
            prefs.setString("SESSION_DATA", json.encode(response.data));
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            setState(() {
              isLoggingin = false;
            });
            print(response.data[0]["message"]);
            showInFlushBar(context, response.data[0]["message"], _scaffoldKey);
          }
        });
      } on DioError catch (e) {
        setState(() {
          isLoggingin = false;
        });
        print(e.error);
        print("this is error => " + e.response.data[0]["message"]);
        showInFlushBar(context, e.response.data[0]["message"], _scaffoldKey);
      }
    } else {
      setState(() {
        isLoggingin = false;
      });
      print("fill all fields");
    }
  }
}
