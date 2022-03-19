import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterconnection/Helpers/Dataconstants.dart';
import 'package:waterconnection/Helpers/FlavConfig.dart';
import 'package:waterconnection/Helpers/NetworkHelprs.dart';
import 'package:waterconnection/Helpers/SessionData.dart';
import 'package:waterconnection/Helpers/WaterConnectionDBHelper.dart';
import 'package:waterconnection/Models/MeterReadingDB.dart';
import 'package:waterconnection/UI/LoginScreen.dart';

class WaterConnection extends StatefulWidget {
  WaterConnection({Key key}) : super(key: key);

  @override
  _WaterConnectionState createState() => _WaterConnectionState();
}

class _WaterConnectionState extends State<WaterConnection> {
  final dbRef = WaterConnectionDBHelper();
  SharedPreferences prefs;
  AutovalidateMode formAutoValidate = AutovalidateMode.disabled;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  File imagePath;
  String fileName;
  String latitude;
  String longitude;
  Position _currentPosition;
  final ImagePicker _picker = ImagePicker();
  TextEditingController consumerName = new TextEditingController();
  TextEditingController consumerAddress = new TextEditingController();
  TextEditingController meterReading = new TextEditingController();
  TextEditingController meterNumber = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (dbRef == null) dbRef.meterReadingDbinit();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
        title: Text("Water Meter"),
        actions: [
          Switch(
            value: Dataconstants.isOfflineSave,
            // activeThumbImage: AssetImage("assets/AppLogo.jpg"),
            onChanged: (value) {
              setState(() {
                Dataconstants.isOfflineSave = value;
                print(Dataconstants.isOfflineSave);
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
          IconButton(
              icon: Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () async {
                prefs = await SharedPreferences.getInstance();
                prefs.remove("loggedin");
                prefs.remove("token");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              })
        ],
        backgroundColor: Colors.green[900]);
    return WillPopScope(
      onWillPop: () async => false,
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: InkWell(
                    onTap: () {
                      Dataconstants.isOfflineSave
                          ? offlineSave()
                          : submitDetails();
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        Dataconstants.isOfflineSave ? "Offline Save" : "Save",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                ),
                appBar: appBar,
                body: Container(
                  height: MediaQuery.of(context).size.height -
                      appBar.preferredSize.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 25,
                        color: Dataconstants.isOfflineSave
                            ? Colors.red
                            : Colors.green,
                        child: Text(
                            Dataconstants.isOfflineSave
                                ? "Offline Mode"
                                : "Online Mode",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 5, 40, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildTextFormField(
                              'Consumer Name',
                              '',
                              consumerName,
                              false,
                              TextInputType.name,
                              null,
                              AutovalidateMode.disabled,
                            ),
                            buildTextFormField(
                              'Address',
                              '',
                              consumerAddress,
                              true,
                              TextInputType.name,
                              null,
                              AutovalidateMode.disabled,
                            ),
                            buildTextFormField(
                              'Meter Number',
                              '',
                              meterNumber,
                              false,
                              TextInputType.number,
                              null,
                              AutovalidateMode.disabled,
                            ),
                            buildTextFormField(
                              'Meter Reading',
                              '',
                              meterReading,
                              false,
                              TextInputType.number,
                              null,
                              AutovalidateMode.disabled,
                            ),
                            SizedBox(height: 15),
                            Container(
                              // alignment: Alignment.center,
                              width: fileName != null
                                  ? MediaQuery.of(context).size.width / 3
                                  : MediaQuery.of(context).size.width / 2,
                              child: OutlineButton(
                                child: fileName != null
                                    ? Image.file(
                                        imagePath,
                                        height: 150,
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.photo_camera),
                                          SizedBox(width: 10),
                                          Text(
                                            "Add Photo",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                letterSpacing: 2),
                                          ),
                                        ],
                                      ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  getImageFromCamera(context);
                                },
                                // icon: fileName != null
                                //     ? null
                                //     : Icon(Icons.photo_camera)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }

  _getCurrentLocation() async {
    prefs = await SharedPreferences.getInstance();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((value) => {
              setState(() {
                _currentPosition = value;
              })
            });
  }

  void showDialogOnError(
      String title, String message, String btnText, Function function) {
    showDialog(
      context: this.context,
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

  void offlineSave() async {
    if (consumerName.text.isEmpty ||
        consumerAddress.text.isEmpty ||
        meterNumber.text.isEmpty ||
        meterReading.text.isEmpty ||
        imagePath == null) {
      showDialogOnError('Empty Field(s)', 'Please enter all the fields', 'Ok',
          () {
        Navigator.pop(context);
      });

      return;
    }

    dbRef.meterReadingDbinit();

    final createDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    // var currentTimeInSecs = Utils.currentTimeInSeconds();
    print("this is created at date  =>" + createDate);

    final meterReadings = MeterReadingDb(
        consumerName: consumerName.text,
        consumerPhoto: imagePath.path,
        meterNumber: int.parse(meterNumber.text),
        meterReading: int.parse(meterReading.text),
        consumerAddress: consumerAddress.text,
        latitude: _currentPosition.latitude.toString(),
        longitude: _currentPosition.longitude.toString(),
        createdAt: createDate,
        branchId: SessionData().data.branchId,
        uploadStatus: Dataconstants.isOfflineSave ? "No" : "Yes");

    dbRef.saveMeterReading(meterReadings);

    final connectionList = await dbRef.getMeterReadingsList();
    print(connectionList[0].consumerName);
    print(connectionList[0].consumerAddress);
    print(connectionList[0].consumerPhoto);
    // print(DateTime.parse(connectionList[0].createdAt));
    setState(() {
      consumerName.text = "";
      consumerAddress.text = '';
      meterNumber.text = '';
      meterReading.text = '';
      imagePath = null;
      fileName = null;
    });
  }

  void submitDetails() async {
    if (consumerName.text.isEmpty ||
        consumerAddress.text.isEmpty ||
        meterNumber.text.isEmpty ||
        meterReading.text.isEmpty ||
        imagePath == null) {
      showDialogOnError('Empty Field(s)', 'Please enter all the fields', 'Ok',
          () {
        Navigator.pop(context);
      });

      return;
    }

    String url =
        FlavorConfig.instance.url() + "/MeterConnections/addConnection";

    FormData formData = FormData.fromMap({
      "name": consumerName.text,
      "address": consumerAddress.text,
      "meter_reading": meterReading.text,
      "meter_number": meterNumber.text,
      "createdBy": SessionData().data.id,
      "lat": _currentPosition.latitude.toString(),
      "lang": _currentPosition.longitude.toString(),
      "branchId": SessionData().data.branchId,
      "media": await MultipartFile.fromFile(imagePath.path, filename: fileName)
    });

    print(formData.fields);

    setState(() {
      formAutoValidate = AutovalidateMode.disabled;
      _isLoading = true;
    });

    print("this is add conection api => $url");
    try {
      await getDio("formdata").post(url, data: formData).then((response) {
        print(response.statusCode);
        print(response.data);
        print("inside code => " + response.data["code"].toString());
        print("inside mesg => " + response.data["message"]);
        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
          });
          if (response.data["code"] == 200) {
            setState(() {
              formAutoValidate = AutovalidateMode.onUserInteraction;
            });
            print(response.data["message"]);

            final createDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
            // var currentTimeInSecs = Utils.currentTimeInSeconds();
            print("this is created at date  =>" + createDate);

            final meterReadings = MeterReadingDb(
                consumerName: consumerName.text,
                consumerPhoto: imagePath.path,
                meterNumber: int.parse(meterNumber.text),
                meterReading: int.parse(meterReading.text),
                consumerAddress: consumerAddress.text,
                latitude: _currentPosition.latitude.toString(),
                longitude: _currentPosition.longitude.toString(),
                createdAt: createDate,
                branchId: SessionData().data.branchId,
                uploadStatus: Dataconstants.isOfflineSave ? "No" : "Yes");

            dbRef.saveMeterReading(meterReadings);

            setState(() {
              consumerName.text = "";
              consumerAddress.text = '';
              meterNumber.text = '';
              meterReading.text = '';
              imagePath = null;
              fileName = null;
            });

            showDialogOnError("Successful", response.data["message"], "Ok", () {
              Navigator.pop(this.context);
            });
          } else if (response.statusCode == 403) {
            setState(() {
              formAutoValidate = AutovalidateMode.onUserInteraction;
              _isLoading = false;
            });
            print(response.data);
            showInFlushBar(context, response.data[0]["message"], _scaffoldKey);
            SessionData().settoken(response.data[0]["new-token"]);
            print(SessionData().data.token);
            showDialogOnError(
                "Session Timeout", "Your session has expired", "Retry", () {
              Navigator.pop(this.context);
              submitDetails();
            });
          }
        } else {
          setState(() {
            formAutoValidate = AutovalidateMode.onUserInteraction;
            _isLoading = false;
          });
          print(response.statusMessage);
        }
      });
    } on DioError catch (e) {
      setState(() {
        formAutoValidate = AutovalidateMode.disabled;
        _isLoading = false;
      });
      print(
          "this is status code submit => " + e.response.statusCode.toString());
      print("this is status code submit => " + e.response.statusMessage);
      print("this is data error => " + e.response.data.toString());
      if (e.response.statusCode == 403) {
        log("this is error => " + e.response.data[0]["message"]);
        SessionData().settoken(e.response.data[0]["new-token"]);
        prefs.setString("token", e.response.data[0]["new-token"]);
        showDialogOnError("Session Timeout",
            "Your session has expired, please retry !", "Retry", () {
          Navigator.pop(this.context);
          submitDetails();

          // Navigator.pushReplacement(this.context,
          //     MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      } else {
        log('this is failed response ${e.response.data}');
        showInFlushBar(
            this.context, e.response.data[0]["message"], _scaffoldKey);
      }
    }
  }

  Future getImageFromCamera(BuildContext changeImgContext) async {
    imageCache.maximumSize = 0;
    imageCache.clear();
    try {
      // var image1 = await _picker.getImage(
      //   source: ImageSource.camera,
      //   maxHeight: 200,
      //   maxWidth: 200,
      // );
      var image1 = await ImagesPicker.pick(
        count: 1,
        pickType: PickType.image,
        quality: 2.0,
      );
      setState(() {
        imagePath = File(image1[0].path);
        fileName = imagePath.path.split('/').last;
      });
    } catch (e) {
      print(e.code);
    }
    // <---------       END      -------->
  }

  Container buildTextFormField(
      String fieldName,
      String suffixText,
      TextEditingController controller,
      bool expands,
      TextInputType textInputType,
      int maxLength,
      AutovalidateMode autovalidateMode) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            fieldName + " *",
            style:
                TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
          ),
          Container(
            // height: 40,
            child: TextFormField(
                // autovalidateMode: autovalidateMode,
                minLines: expands ? null : 1,
                maxLines: expands ? null : 1,
                maxLength: maxLength,
                textCapitalization: TextCapitalization.words,
                validator: (text) {
                  // if (controller == consumerMobile) {
                  //   if (text.isEmpty || text.length < 10 || text.length > 10) {
                  //     return "Mobile Number should be 10 digits";
                  //   }
                  // } else {
                  if (text.isEmpty) {
                    return "Field should not be empty";
                  }
                  // }
                  return null;
                },
                enableSuggestions: true,
                autocorrect: false,
                keyboardType: textInputType,
                controller: controller,
                decoration: InputDecoration(
                    suffixText: suffixText,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black26)),
                    labelStyle: TextStyle(color: Colors.black54))),
          ),
        ],
      ),
    );
  }
}
