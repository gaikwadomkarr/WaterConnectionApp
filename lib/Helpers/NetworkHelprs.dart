import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:waterconnection/Helpers/SessionData.dart';

Dio getDio(String requestType) {
  Dio dio = new Dio();
  dio.options.followRedirects = false;
  if (requestType == "json") {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
  } else if (requestType == "formdata") {
    print("inside formData");
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = '*/*';
  }
  if (SessionData().data.token != null) {
    dio.options.headers['Authorization'] = 'Bearer ' + SessionData().data.token;
  }
  //dio.interceptors.add(DioFirebasePerformanceInterceptor());
  dio.options.responseType = ResponseType.json;

  return dio;
}

void showInFlushBar(context, String value, GlobalKey<ScaffoldState> _key) {
  FocusScope.of(context).requestFocus(new FocusNode());
  _key.currentState?.removeCurrentSnackBar();

  Flushbar(
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    reverseAnimationCurve: Curves.fastOutSlowIn,
    animationDuration: Duration(milliseconds: 500),
    messageText: Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.green[900],
  )..show(context);
}

void showRetryDialog(BuildContext context, String title, String message,
    String btnText, Function function) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          new FlatButton(
            child: new Text(btnText),
            onPressed: function,
          ),
        ],
      );
    },
  );
}

TextStyle greenStyle() {
  return TextStyle(color: Colors.green[900], fontWeight: FontWeight.normal);
}

TextStyle blackStyle() {
  return TextStyle(color: Colors.black, fontWeight: FontWeight.normal);
}
