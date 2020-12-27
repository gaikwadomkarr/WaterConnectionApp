import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Container(
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
                        Container(
                          height: 45,
                          child: TextFormField(
                              autocorrect: false,
                              controller: username,
                              decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.person, color: Colors.black),
                                  enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 0.9),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  focusedBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 0.9),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Colors.black)),
                                  labelText: "Username *",
                                  labelStyle:
                                      TextStyle(color: Colors.black54))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 45,
                          child: TextFormField(
                              autocorrect: false,
                              controller: username,
                              obscureText: true,
                              decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.lock, color: Colors.black),
                                  suffixIcon: Icon(
                                    Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 0.9),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  focusedBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 0.9),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Colors.black)),
                                  labelText: "Password *",
                                  labelStyle:
                                      TextStyle(color: Colors.black54))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {},
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
              ))),
    );
  }
}
