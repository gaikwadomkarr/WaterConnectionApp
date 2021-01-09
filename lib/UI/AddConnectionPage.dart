import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waterconnection/Helpers/FlavConfig.dart';
import 'package:path_provider/path_provider.dart';
import 'package:waterconnection/Helpers/NetworkHelprs.dart';
import 'package:waterconnection/Helpers/SessionData.dart';
import 'package:waterconnection/Models/GetContractors.dart';
import 'package:waterconnection/Models/GetSaddles.dart';
import 'package:waterconnection/Models/GetZones.dart';

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
  final _formKey = GlobalKey<FormState>();
  GetContractors getContractors;
  GetSaddles getSaddles;
  GetZones getZones;
  bool ferruleValue;
  bool roadCrossingValue;
  File imagePath;
  String fileName;
  bool btnEnabled = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getContractorsApi();
    getSaddlesApi();
    getZonesApi();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("Add Connection"), backgroundColor: Colors.green[900]),
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.fromLTRB(40, 5, 40, 20),
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  // shrinkWrap: true,
                  children: [
                    buildDropdownButtonFormField(
                        "Contractor", selectedCOntractor, tempContractors),
                    buildTextFormField("Consumer Name", null, consumerName,
                        false, TextInputType.name, null),
                    buildDropdownButtonFormField(
                        "Zone", selectedZone, tempZones),
                    buildTextFormField("Address", null, consumerAddress, true,
                        TextInputType.streetAddress, null),
                    buildTextFormField("Mobile No.", null, consumerMobile,
                        false, TextInputType.number, 10),
                    buildDropdownButtonFormField(
                        "Saddle", selectedSaddle, tempSaddles),
                    buildFerruleRadioButton("Ferrule"),
                    buildRoadCrossingRadioButton("Road Crossing"),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 2.8,
                      child: buildTextFormField("MDPE Pipe Length", "mtrs",
                          mdpePipeLenth, false, TextInputType.number, null),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
      List<DropdownMenuItem<String>> data) {
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
              autovalidateMode: AutovalidateMode.disabled,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "Please select a value";
              //   }
              //   return null;
              // },
              value: valueHolder,
              isExpanded: true,
              // underline: Container(
              //   height: 1,
              //   color: Colors.black26,
              // ),
              icon: Icon(Icons.keyboard_arrow_down_outlined),
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
    if (_formKey.currentState.validate()) {
      print("aal fileds filled");
      setState(() {
        btnEnabled = true;
      });
    } else {
      print("aal fileds not filled");
      setState(() {
        btnEnabled = false;
      });
    }
  }

  Container buildTextFormField(
      String fieldName,
      String suffixText,
      TextEditingController controller,
      bool expands,
      TextInputType textInputType,
      int maxLength) {
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
                autovalidateMode: AutovalidateMode.disabled,
                minLines: expands ? null : 1,
                maxLines: expands ? null : 1,
                maxLength: maxLength,
                onChanged: (text) {
                  // isEmpty();
                },
                // validator: (text) {
                //   if (controller == consumerMobile) {
                //     if (text.isEmpty || text.length < 10) {
                //       return "Mobile Number should be 10 digits";
                //     }
                //   } else {
                //     if (text.isEmpty) {
                //       return "Field should not be empty";
                //     }
                //   }
                //   return null;
                // },
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
    print("this is token from sessiondata => " +
        SessionData().data.token.toString());
    String getContractorUrl =
        FlavorConfig.instance.url() + "/Master/getContracters";
    print(getContractorUrl);
    await getDio("json").post(getContractorUrl).then((response) {
      print("this is getcontractor api ${response.statusCode}");
      print("this is getcontractor api ${response.data}");

      if (response.statusCode == 200) {
        getContractors = GetContractors.fromJson(response.data);
        getContractors.data.forEach((e) {
          tempContractors.add(
              DropdownMenuItem(value: e.id.toString(), child: Text(e.name)));
          setState(() {});
        });
        print(getContractors.data[0].name);
      } else {}
      // var data = response.data as List;
    });
  }

  void getSaddlesApi() async {
    print("this is token from sessiondata => " +
        SessionData().data.token.toString());
    String getSaddlesUrl = FlavorConfig.instance.url() + "/Master/getSaddles";
    print(getSaddlesUrl);
    await getDio("json").post(getSaddlesUrl).then((response) {
      print("this is getcontractor api ${response.statusCode}");
      print("this is getcontractor api ${response.data}");

      if (response.statusCode == 200) {
        getSaddles = GetSaddles.fromJson(response.data);
        getSaddles.data.forEach((e) {
          tempSaddles.add(DropdownMenuItem(
              value: e.id.toString(), child: Text(e.saddleName)));
          setState(() {});
        });
        print(getSaddles.data[0].saddleName);
      } else {}
      // var data = response.data as List;
    });
  }

  void getZonesApi() async {
    print("this is token from sessiondata => " +
        SessionData().data.token.toString());
    String getZonesUrl = FlavorConfig.instance.url() + "/Master/getZones";
    print(getZonesUrl);
    await getDio("json").post(getZonesUrl).then((response) {
      print("this is getcontractor api ${response.statusCode}");
      print("this is getcontractor api ${response.data}");

      if (response.statusCode == 200) {
        getZones = GetZones.fromJson(response.data);
        getZones.data.forEach((e) {
          tempZones.add(DropdownMenuItem(
              value: e.id.toString(), child: Text(e.zoneName)));
          setState(() {});
        });
        print(getZones.data[0].zoneName);
      } else {}
      // var data = response.data as List;
    });
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
      "address": consumerAddress.text,
      "zoneId": selectedZone,
      "saddleId": selectedSaddle,
      "isFerrule": ferruleValue ? 1 : 0,
      "isRoadCrossing": roadCrossingValue ? 1 : 0,
      "pipeSize": mdpePipeLenth.text,
      "createdBy": 1,
      "latitude": 22.000,
      "longitude": 45.000,
      "media": await MultipartFile.fromFile(imagePath.path, filename: fileName)
    });

    await getDio("formdata").post(url, data: formData).then((response) {
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data["message"]);
      } else if (response.statusCode == 403) {
        print(response.data);
        SessionData().settoken(response.data["new-token"]);
      } else {
        print(response.statusMessage);
      }
    });
  }
}
