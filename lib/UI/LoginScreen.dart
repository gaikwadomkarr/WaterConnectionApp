import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool obscure = true;

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
                            child: buildTextFormField(
                                username,
                                false,
                                Icon(Icons.person, color: Colors.black),
                                null,
                                "Username *")),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 45,
                          child: buildTextFormField(
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
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: null));
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
              ))),
    );
  }

  TextFormField buildTextFormField(TextEditingController controller,
      bool obscureText, Icon prefixIcon, Widget suffixIcon, String labelText) {
    return TextFormField(
        autocorrect: false,
        controller: controller,
        obscureText: obscureText,
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
            labelStyle: TextStyle(color: Colors.black54)));
  }
}
