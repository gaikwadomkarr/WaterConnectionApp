import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterconnection/Helpers/FlavConfig.dart';
import 'package:path_provider/path_provider.dart';
import 'package:waterconnection/Helpers/NetworkHelprs.dart';
import 'package:waterconnection/Helpers/SessionData.dart';
import 'package:waterconnection/Models/GetContractors.dart';
import 'package:waterconnection/Models/GetSaddles.dart';
import 'package:waterconnection/Models/GetZones.dart';
import 'package:waterconnection/UI/LoginScreen.dart';

class AddConnectionPage extends StatefulWidget {
  AddConnectionPage({Key key}) : super(key: key);

  @override
  _AddConnectionPageState createState() => _AddConnectionPageState();
}

enum FerruleCharacter { yes, no }
enum RoadCrossingCharacter { yes, no }

class _AddConnectionPageState extends State<AddConnectionPage> {
  String selectedCOntractor;
  String selectedZone;
  String selectedSaddle;
  TextEditingController consumerName = new TextEditingController();
  TextEditingController consumerAddress = new TextEditingController();
  TextEditingController consumerMobile = new TextEditingController();
  TextEditingController mdpePipeLenth = new TextEditingController();
  List<DropdownMenuItem<String>> tempContractors = [];
  List<DropdownMenuItem<String>> tempSaddles = [];
  List<DropdownMenuItem<String>> tempZones = [];
  final _formKeyConnection = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GetContractors getContractors;
  GetSaddles getSaddles;
  GetZones getZones;
  bool ferruleValue;
  bool roadCrossingValue;
  File imagePath;
  String fileName;
  bool btnEnabled = true;
  bool _isLoading = false;
  bool _isContractorLoading = false;
  bool _isSaddleLoading = false;
  bool _isZoneLoading = false;
  bool _isErrorShown = false;
  int getApiCount = 0;
  String latitude;
  String longitude;
  final ImagePicker _picker = ImagePicker();
  Position _currentPosition;
  AutovalidateMode formAutoValidate = AutovalidateMode.disabled;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    retryFunction();
  }

  void retryFunction() {
    getContractorsApi();
  }

  void showDialogOnError(BuildContext context, String title, String message,
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

  _getCurrentLocation() async {
    prefs = await SharedPreferences.getInstance();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((value) => {
              setState(() {
                _currentPosition = value;
              })
            });
  }

  Future getImageFromCamera(BuildContext changeImgContext) async {
    var image1 = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      imagePath = File(image1.path);
      fileName = imagePath.path.split('/').last;
    });

    // <---------       END      -------->
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text("Add Connection"),
                actions: [
                  IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () async {
                        prefs = await SharedPreferences.getInstance();
                        prefs.remove("loggedin");
                        prefs.remove("token");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      })
                ],
                backgroundColor: Colors.green[900]),
            body: Form(
              key: _formKeyConnection,
              child: Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.fromLTRB(40, 5, 40, 20),
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      // shrinkWrap: true,
                      children: [
                        buildDropdownButtonFormField(
                            "Contractor",
                            selectedCOntractor,
                            tempContractors,
                            _isContractorLoading),
                        buildTextFormField("Consumer Name", null, consumerName,
                            false, TextInputType.name, null, formAutoValidate),
                        // Container(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       SizedBox(height: 15),
                        //       Text(
                        //         "Consumer Name" + " *",
                        //         style: TextStyle(
                        //             color: Colors.black38,
                        //             fontWeight: FontWeight.w500),
                        //       ),
                        //       Container(
                        //         // height: 40,
                        //         child: TextFormField(
                        //             minLines: false ? null : 1,
                        //             maxLines: false ? null : 1,
                        //             maxLength: null,
                        //             validator: (text) {
                        //               // if (controller == consumerMobile) {
                        //               //   if (text.isEmpty || text.length < 10 || text.length > 10) {
                        //               //     return "Mobile Number should be 10 digits";
                        //               //   }
                        //               // } else {
                        //               if (text.isEmpty) {
                        //                 return "Field should not be empty";
                        //               }
                        //               // }
                        //               return null;
                        //             },
                        //             enableSuggestions: true,
                        //             autocorrect: false,
                        //             keyboardType: TextInputType.name,
                        //             controller: consumerName,
                        //             decoration: InputDecoration(
                        //                 enabledBorder: UnderlineInputBorder(
                        //                     borderSide: const BorderSide(
                        //                         color: Colors.black26)),
                        //                 labelStyle:
                        //                     TextStyle(color: Colors.black54))),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        buildDropdownButtonFormField(
                            "Zone", selectedZone, tempZones, _isZoneLoading),
                        buildTextFormField(
                            "Address",
                            null,
                            consumerAddress,
                            true,
                            TextInputType.streetAddress,
                            null,
                            formAutoValidate),
                        buildTextFormField("Mobile No.", null, consumerMobile,
                            false, TextInputType.number, 10, formAutoValidate),
                        buildDropdownButtonFormField("Saddle", selectedSaddle,
                            tempSaddles, _isSaddleLoading),
                        buildFerruleRadioButton("Ferrule"),
                        buildRoadCrossingRadioButton("Road Crossing"),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width / 2.8,
                          child: buildTextFormField(
                              "MDPE Pipe Length",
                              "mtrs",
                              mdpePipeLenth,
                              false,
                              TextInputType.number,
                              null,
                              formAutoValidate),
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              getImageFromCamera(context);
                            },
                            // icon: fileName != null
                            //     ? null
                            //     : Icon(Icons.photo_camera)
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width / 1,
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: btnEnabled
                                ? () {
                                    isEmpty();
                                  }
                                : null,
                            color: btnEnabled ? Colors.black : Colors.black54,
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  letterSpacing: 2),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildFerruleRadioButton(String fieldName) {
    return Container(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            fieldName + " *",
            style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.normal),
          ),
          Spacer(
            flex: 1,
          ),
          Container(
            // width: 45,
            child: Row(
              children: [
                Radio<bool>(
                  activeColor: Colors.green[900],
                  value: true,
                  groupValue: ferruleValue,
                  onChanged: (bool value) {
                    print("new value is => $value");
                    setState(() {
                      ferruleValue = value;
                    });
                    print("new value is => $ferruleValue");
                  },
                ),
                Text(
                  'Yes',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Container(
            // width: 45,
            child: Row(
              children: [
                Radio<bool>(
                  activeColor: Colors.green[900],
                  value: false,
                  groupValue: ferruleValue,
                  onChanged: (bool value) {
                    print("new value is => $value");
                    setState(() {
                      ferruleValue = value;
                    });
                    print("new value is => $ferruleValue");
                  },
                ),
                Text(
                  'No',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildRoadCrossingRadioButton(String fieldName) {
    return Container(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            fieldName + " *",
            style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.normal),
          ),
          Spacer(
            flex: 1,
          ),
          Container(
            // width: 45,
            child: Row(
              children: [
                Radio<bool>(
                  activeColor: Colors.green[900],
                  value: true,
                  groupValue: roadCrossingValue,
                  onChanged: (bool value) {
                    print("new value is => $value");
                    setState(() {
                      roadCrossingValue = value;
                    });
                    print("new value is => $roadCrossingValue");
                  },
                ),
                Text(
                  'Yes',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Container(
            // width: 45,
            child: Row(
              children: [
                Radio<bool>(
                  activeColor: Colors.green[900],
                  value: false,
                  groupValue: roadCrossingValue,
                  onChanged: (bool value) {
                    print("new value is => $value");
                    setState(() {
                      roadCrossingValue = value;
                    });
                    print("new value is => $roadCrossingValue");
                  },
                ),
                Text(
                  'No',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildDropdownButtonFormField(String fieldName, String valueHolder,
      List<DropdownMenuItem<String>> data, bool isLoading) {
    return Container(
      // height: 45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            fieldName + " *",
            style:
                TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
          ),
          new DropdownButtonFormField(
              // itemHeight: 25,

              // autovalidateMode: formAutoValidate,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select a value";
                }
                return null;
              },
              value: valueHolder,
              isExpanded: true,
              // underline: Container(
              //   height: 1,
              //   color: Colors.black26,
              // ),
              icon: isLoading
                  ? Container(
                      padding: EdgeInsets.all(2),
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ))
                  : Icon(Icons.keyboard_arrow_down_outlined),
              decoration: InputDecoration(
                  //     labelText: "Contractor *",
                  //     enabledBorder: const OutlineInputBorder(
                  //       // width: 0.0 produces a thin "hairline" border
                  //       borderSide: const BorderSide(color: Colors.black, width: 1),
                  //     ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26))),
              items: data,
              onChanged: (String newValue) {
                setState(() {
                  print(newValue);
                  if (fieldName == "Contractor") {
                    selectedCOntractor = newValue;
                  } else if (fieldName == "Zone") {
                    selectedZone = newValue;
                  } else {
                    selectedSaddle = newValue;
                  }
                  valueHolder = newValue;
                  print(valueHolder);
                });
                // isEmpty();
              }),
        ],
      ),
    );
  }

  void isEmpty() {
    print("called empty");
    var flag = 0;
    if (_formKeyConnection.currentState.validate()) {
      print("aal fileds filled");
      if (ferruleValue == null) {
        flag = 1;
        showInFlushBar(
            this.context, "Please select Ferrule value", _scaffoldKey);
        return;
      }
      if (roadCrossingValue == null) {
        flag = 1;
        showInFlushBar(
            this.context, "Please select Road Crossing value", _scaffoldKey);
        return;
      }
      if (imagePath == null) {
        flag = 1;
        showInFlushBar(this.context, "Please select image", _scaffoldKey);
        return;
      }

      if (flag == 0) {
        submitDetails();
      }
    } else {
      print("aal fileds not filled");
    }
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
                validator: (text) {
                  if (controller == consumerMobile) {
                    if (text.isEmpty || text.length < 10 || text.length > 10) {
                      return "Mobile Number should be 10 digits";
                    }
                  } else {
                    if (text.isEmpty) {
                      return "Field should not be empty";
                    }
                  }
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

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory.path;
  }

  void getContractorsApi() async {
    setState(() {
      _isContractorLoading = true;
    });
    print("this is token from sessiondata => " +
        SessionData().data.token.toString());
    String getContractorUrl = FlavorConfig.instance.url() +
        "/Master/getContracters?userId=${SessionData().data.id}";
    print(getContractorUrl);
    try {
      await getDio("json").get(getContractorUrl).then((response) {
        print("this is getcontractor api ${response.statusCode}");
        print("this is getcontractor api ${response.data}");

        if (response.statusCode == 200) {
          getContractors = GetContractors.fromJson(response.data);
          setState(() {
            _isContractorLoading = false;
          });
          getContractors.data.forEach((e) {
            tempContractors.add(
                DropdownMenuItem(value: e.id.toString(), child: Text(e.name)));
            setState(() {});
          });
          print(getContractors.data[0].name);
          getSaddlesApi();
          getZonesApi();
        } else if (response.statusCode == 403) {
          setState(() {
            _isContractorLoading = false;
          });
          print(response.data);

          print(SessionData().data.token);
        } else {
          setState(() {
            _isContractorLoading = false;
          });
        }
        // var data = response.data as List;
      });
    } on DioError catch (e) {
      setState(() {
        _isContractorLoading = false;
      });
      print(e.response.data[0]["message"]);
      print(e.response.data[0]["new-token"]);
      if (!_isErrorShown) {
        print("entered contractor retry");
        setState(() {
          _isErrorShown = true;
        });
        SessionData().settoken(e.response.data[0]["new-token"]);
        prefs.setString("token", e.response.data[0]["new-token"]);
        showDialogOnError(this.context, "Session Timeout",
            "Your session has expired. Please retry !", "Retry", () {
          retryFunction();
          Navigator.pop(this.context);
          // Navigator.pushReplacement(this.context,
          //     MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      }
    }
  }

  void getSaddlesApi() async {
    setState(() {
      _isSaddleLoading = true;
    });
    print("this is token from sessiondata => " +
        SessionData().data.token.toString());
    String getSaddlesUrl = FlavorConfig.instance.url() +
        "/Master/getSaddles?userId=${SessionData().data.id}";
    print(getSaddlesUrl);
    try {
      await getDio("json").get(getSaddlesUrl).then((response) {
        print("this is getcontractor api ${response.statusCode}");
        print("this is getcontractor api ${response.data}");

        if (response.statusCode == 200) {
          getSaddles = GetSaddles.fromJson(response.data);
          setState(() {
            _isSaddleLoading = false;
          });
          getSaddles.data.forEach((e) {
            tempSaddles.add(DropdownMenuItem(
                value: e.id.toString(), child: Text(e.saddleName)));
            setState(() {});
          });
          print(getSaddles.data[0].saddleName);
        } else if (response.statusCode == 403) {
          setState(() {
            _isContractorLoading = false;
          });
          print(response.data);

          print(SessionData().data.token);
          if (!_isErrorShown) {
            setState(() {
              _isErrorShown = true;
            });
            print("entered contractor retry");
            SessionData().settoken(response.data[0]["new-token"]);
            showDialogOnError(this.context, "Session Timeout",
                "Your session has expired. Please retry !", "Retry", () {
              retryFunction();
              Navigator.pop(this.context);

              Navigator.pushReplacement(this.context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            });
          }
        } else {
          setState(() {
            _isSaddleLoading = false;
          });
        }
        // var data = response.data as List;
      });
    } on DioError catch (e) {
      setState(() {
        _isSaddleLoading = false;
      });
      print(e.response.data[0]["message"]);
      print(e.response.data[0]["new-token"]);
      if (!_isErrorShown) {
        SessionData().settoken(e.response.data[0]["new-token"]);
        prefs.setString("token", e.response.data[0]["new-token"]);
        showDialogOnError(this.context, "Session Timeout",
            "Your session has expired. Please retry !", "Retry", () {
          retryFunction();
          Navigator.pop(this.context);
          // Navigator.pushReplacement(this.context,
          //     MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      }
    }
  }

  void getZonesApi() async {
    setState(() {
      _isZoneLoading = true;
    });
    print("this is token from sessiondata => " +
        SessionData().data.token.toString());
    String getZonesUrl = FlavorConfig.instance.url() +
        "/Master/getZones?userId=${SessionData().data.id}";
    print(getZonesUrl);
    try {
      await getDio("json").get(getZonesUrl).then((response) {
        print("this is getcontractor api ${response.statusCode}");
        print("this is getcontractor api ${response.data}");

        if (response.statusCode == 200) {
          getZones = GetZones.fromJson(response.data);
          setState(() {
            _isZoneLoading = false;
          });
          getZones.data.forEach((e) {
            tempZones.add(DropdownMenuItem(
                value: e.id.toString(), child: Text(e.zoneName)));
            setState(() {});
          });
          print(getZones.data[0].zoneName);
        } else if (response.statusCode == 403) {
          setState(() {
            _isContractorLoading = false;
          });
          print(response.data);

          print(SessionData().data.token);
          if (!_isErrorShown) {
            setState(() {
              _isErrorShown = true;
            });
            SessionData().settoken(response.data[0]["new-token"]);
            showDialogOnError(this.context, "Session Timeout",
                "Your session has expired. Please retry !", "Retry", () {
              retryFunction();
              Navigator.pop(this.context);

              Navigator.pushReplacement(this.context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            });
          }
        } else {
          setState(() {
            _isZoneLoading = false;
          });
        }
        // var data = response.data as List;
      });
    } on DioError catch (e) {
      setState(() {
        _isZoneLoading = false;
      });
      print(e.response.data[0]["message"]);
      print(e.response.data[0]["new-token"]);
      if (!_isErrorShown) {
        print("entered contractor retry");
        SessionData().settoken(e.response.data[0]["new-token"]);
        prefs.setString("token", e.response.data[0]["new-token"]);
        showDialogOnError(this.context, "Session Timeout",
            "Your session has expired", "Retry", () {
          retryFunction();
          Navigator.pop(this.context);
        });
      }
    }
  }

  void submitDetails() async {
    String url = FlavorConfig.instance.url() + "/Consumer/addConnection";

    // Excel excel = Excel.createExcel();
    // Sheet sheetObject = excel["Excel 1"];
    // var cell = sheetObject.cell(CellIndex.indexByString("A1"));
    // cell.value = "Omkar Gaikwad";
    // print("CellType: " + cell.cellType.toString());
    // final filePath = await _localPath;
    // String outputFile = filePath + "/r.xlsx";
    // print(outputFile.toString());
    // excel.encode().then((onValue) {
    //   File(join(outputFile))
    //     ..createSync(recursive: true)
    //     ..writeAsBytesSync(onValue);
    // });
    FormData formData = FormData.fromMap({
      "name": consumerName.text,
      "createdBy": SessionData().data.id,
      "address": consumerAddress.text,
      "contractorId": int.parse(selectedCOntractor),
      "zoneId": int.parse(selectedZone),
      "saddleId": int.parse(selectedSaddle),
      "isFerrule": ferruleValue ? 1 : 0,
      "isRoadCrossing": roadCrossingValue ? 1 : 0,
      "pipeSize": mdpePipeLenth.text,
      "lat": _currentPosition.latitude.toString(),
      "lang": _currentPosition.longitude.toString(),
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
              consumerName.text = "";
              consumerAddress.text = "";
              consumerMobile.text = "";
              mdpePipeLenth.text = "";
              selectedCOntractor = null;
              selectedSaddle = null;
              selectedZone = null;
              ferruleValue = null;
              roadCrossingValue = null;
              imagePath = null;
              fileName = null;
            });
            setState(() {
              formAutoValidate = AutovalidateMode.onUserInteraction;
            });
            print(response.data["message"]);
            showInFlushBar(
                this.context, response.data["message"], _scaffoldKey);
          } else if (response.statusCode == 403) {
            setState(() {
              formAutoValidate = AutovalidateMode.onUserInteraction;
              _isLoading = false;
            });
            print(response.data);
            showInFlushBar(context, response.data[0]["message"], _scaffoldKey);
            SessionData().settoken(response.data[0]["new-token"]);
            print(SessionData().data.token);
            showDialogOnError(this.context, "Session Timeout",
                "Your session has expired", "Retry", isEmpty);
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
        print("this is error => " + e.response.data[0]["message"]);
        SessionData().settoken(e.response.data[0]["new-token"]);
        prefs.setString("token", e.response.data[0]["new-token"]);
        showDialogOnError(this.context, "Session Timeout",
            "Your session has expired, please retry !", "Retry", () {
          Navigator.pop(this.context);
          submitDetails();

          // Navigator.pushReplacement(this.context,
          //     MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      } else {
        showInFlushBar(
            this.context, e.response.data[0]["message"], _scaffoldKey);
      }
    }
  }
}
