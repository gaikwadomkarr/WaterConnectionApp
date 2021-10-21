import 'dart:io';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterconnection/Helpers/FlavConfig.dart';
import 'package:waterconnection/Helpers/NetworkHelprs.dart';
import 'package:waterconnection/Helpers/SessionData.dart';
import 'package:waterconnection/Helpers/WaterConnectionDBHelper.dart';
import 'package:waterconnection/Models/ConnectionDB.dart';
import 'package:waterconnection/Models/MeterReadingDB.dart';
import 'package:waterconnection/UI/LoginScreen.dart';

class MeterReadingsPage extends StatefulWidget {
  @override
  _MeterReadingsPageState createState() => _MeterReadingsPageState();
}

class _MeterReadingsPageState extends State<MeterReadingsPage> {
  SharedPreferences prefs;
  int meterReadingCount = 0;
  bool _isLoading = false;
  bool showCrossMark = false;
  bool showdateRange = false;
  DateTimeRange dateRange;
  TextEditingController searchController = new TextEditingController();
  final dbRef = WaterConnectionDBHelper();
  List<MeterReadingDb> meterReadingList;
  List<String> consumerNames = List<String>();
  List<String> consumerPhotos = List<String>();
  List<String> addressList = List<String>();
  List<String> uploadStatusList = List<String>();
  List<String> connectionDates = List<String>();
  List<String> consumerlat = List<String>();
  List<String> consumerlang = List<String>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getDbList();
  }

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory.path;
  }

  void getDbList() async {
    meterReadingList = await dbRef.getMeterReadingsList();
    meterReadingCount = meterReadingList.length;
    setState(() {});
  }

  Widget buildSearchbar() {
    return Container(
      height: 45,
      // width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(color: Colors.green, blurRadius: 5, offset: Offset(0, 1))
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: TextFormField(
        // enabled: !_isDialogShowing,
        decoration: new InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            size: 30,
            color: FlavorConfig.instance.color,
          ),
          suffixIcon: showCrossMark
              ? IconButton(
                  icon: Icon(Icons.highlight_remove_outlined),
                  onPressed: () async {
                    setState(() {
                      searchController.text = "";
                      showCrossMark = false;
                      meterReadingList = null;
                    });
                    meterReadingList = await dbRef.getMeterReadingsList();
                  },
                )
              : null,
          hintText: "Search by name",
          border: InputBorder.none,
          counterText: "",
          hintStyle: blackStyle().copyWith(color: Colors.black54),
        ),
        controller: searchController,
        onChanged: (value) {
          print("Print onChange value $value");
          if (value.length > 0) {
            setState(() {
              showCrossMark = true;
            });
          } else if (value.length == 0) {
            setState(() {
              showCrossMark = false;
            });
          }
          getChangedList(value);
        },
      ),
    );
  }

  void getChangedList(String name) async {
    meterReadingList = null;
    meterReadingList = await dbRef.geMeterReadingsByName(name);
    setState(() {});
  }

  void getEntries() async {
    prefs = await SharedPreferences.getInstance();
    consumerNames = prefs.getStringList("consumerNamesList") ?? [];
    consumerPhotos = prefs.getStringList("consumerPhotosList") ?? [];
    addressList = prefs.getStringList("addressList") ?? [];
    meterReadingCount = consumerNames.length ?? 0;
    uploadStatusList = prefs.getStringList("uploadStatusList") ?? [];
    connectionDates = prefs.getStringList("connectionDates") ?? [];
    consumerlat = prefs.getStringList("consumerlat") ?? [];
    consumerlang = prefs.getStringList("consumerlang") ?? [];
    setState(() {});
  }

  Future<String> _exportAll() async {
    setState(() {
      _isLoading = true;
    });
    // var excludes = new List<dynamic>();
    // var prettify = new Map<dynamic, dynamic>();
    // var finalpath = "";

    // // Exclude column(s) from being exported
    // // excludes.add("order_id");

    // // Prettifies columns name
    // prettify["consumerName"] = "Consumer Name";
    // prettify["consumerMobile"] = "Consumer Mobile";
    // prettify["consumerAddress"] = "Consumer Address";
    // prettify["latitude"] = "Latitude";
    // prettify["longitude"] = "Longitude";
    // prettify["created_at"] = "Created At";
    // prettify["contractor"] = "Contractor";
    // prettify["saddle"] = "Saddle";
    // prettify["zone"] = "Zone";
    // prettify["mdpePipeLength"] = "Pipe Length";
    // prettify["ferrule"] = "Ferrule";
    // prettify["roadCrossing"] = "roadCrossing";

    // // String dbPath = join(await _localPath, 'WaterConnection.db');
    // Directory directory = await getExternalStorageDirectory();
    // // var path = directory.path;
    // String dbPath = join(directory.path, "WaterConnection.db");
    // try {
    //   finalpath = await Sqlitetoexcel.exportSingleTable(
    //       dbPath,
    //       "",
    //       directory.path,
    //       "ExportSingleTable.xls",
    //       "connections",
    //       excludes,
    //       prettify);
    // } on PlatformException catch (e) {
    //   print(e.message.toString());
    // }

    // print("this is final path for excel => " + finalpath);
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel[
        "WMC-MeterReading-${DateFormat("dd-MM-yyyy").format(DateTime.now())}"];
    var rowCount = 1;
    CellStyle headcellStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      italic: false,
      textWrapping: TextWrapping.WrapText,
      fontFamily: getFontFamily(FontFamily.Helvetica_Neue),
    );
    CellStyle valuecellStyle = CellStyle(
      bold: false,
      italic: false,
      fontSize: 8,
      horizontalAlign: HorizontalAlign.Center,
      fontFamily: getFontFamily(FontFamily.Comic_Sans_MS),
    );
    meterReadingList.forEach((reading) {
      var cellA = sheetObject.cell(CellIndex.indexByString("A$rowCount"));
      var cellB = sheetObject.cell(CellIndex.indexByString("B$rowCount"));
      var cellC = sheetObject.cell(CellIndex.indexByString("C$rowCount"));
      var cellD = sheetObject.cell(CellIndex.indexByString("D$rowCount"));
      var cellE = sheetObject.cell(CellIndex.indexByString("E$rowCount"));
      var cellF = sheetObject.cell(CellIndex.indexByString("F$rowCount"));
      var cellG = sheetObject.cell(CellIndex.indexByString("G$rowCount"));
      var cellH = sheetObject.cell(CellIndex.indexByString("H$rowCount"));
      if (rowCount == 1) {
        cellA.value = "Consumer Name";
        cellA.cellStyle = headcellStyle;

        cellB.value = "Consumer Address";
        cellB.cellStyle = headcellStyle;

        cellC.value = "Latitude";
        cellC.cellStyle = headcellStyle;

        cellD.value = "Longitude";
        cellD.cellStyle = headcellStyle;

        cellE.value = "Created At";
        cellE.cellStyle = headcellStyle;

        cellF.value = "Meter Number";
        cellF.cellStyle = headcellStyle;

        cellG.value = "Meter Reading";
        cellG.cellStyle = headcellStyle;

        cellH.value = "Upload Status";
        cellH.cellStyle = headcellStyle;
      } else {
        cellA.value = reading.consumerName;
        cellA.cellStyle = valuecellStyle;

        cellB.value = reading.consumerAddress;
        cellB.cellStyle = valuecellStyle;

        cellC.value = reading.latitude;
        cellC.cellStyle = valuecellStyle;

        cellD.value = reading.longitude;
        cellD.cellStyle = valuecellStyle;

        cellE.value = reading.createdAt;
        cellE.cellStyle = valuecellStyle;

        cellF.value = reading.meterNumber;
        cellF.cellStyle = valuecellStyle;

        cellG.value = reading.meterReading;
        cellG.cellStyle = valuecellStyle;

        cellH.value = reading.uploadStatus;
        cellH.cellStyle = valuecellStyle;
      }
      rowCount += 1;
    });
    // var cell = sheetObject.cell(CellIndex.indexByString("A1"));
    // cell.value = "Omkar Gaikwad";
    // print("CellType: " + cell.cellType.toString());
    final filePath = await _localPath;
    String outputFile = filePath +
        "/WMC-MeterReading-${DateFormat("dd-MM-yyyy").format(DateTime.now())}.xlsx";
    print(outputFile.toString());
    excel.encode().then((onValue) {
      File(join(outputFile))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    setState(() {
      _isLoading = false;
    });

    showDialogOnError("Excel Saved",
        "Excel file created successfully at \n\n$outputFile", "Ok", () {
      Navigator.pop(this.context);
    });

    print("this is final path for excel => " + outputFile);
    return outputFile;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text("Meter Readings ($meterReadingCount)"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.download_outlined),
                    tooltip: "Export Data",
                    onPressed: () {
                      _exportAll();
                    },
                  ),
                  IconButton(
                      icon: Icon(Icons.cloud_upload_outlined),
                      tooltip: "Upload to server",
                      onPressed: () async {
                        submitDetails();
                      }),
                  IconButton(
                      icon: Icon(Icons.logout),
                      tooltip: "Logout",
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
            body: Center(
                child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    !showdateRange
                        ? Flexible(flex: 8, child: buildSearchbar())
                        : Flexible(
                            flex: 8,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.green,
                                      blurRadius: 5,
                                      offset: Offset(0, 1))
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: DateFormat("dd/MM/yyyy")
                                            .format(dateRange.start),
                                        style: greenStyle().copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: "   To    ",
                                        style: greenStyle(),
                                      ),
                                      TextSpan(
                                        text: DateFormat("dd/MM/yyyy")
                                            .format(dateRange.end),
                                        style: greenStyle().copyWith(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ])),
                                  ),
                                  IconButton(
                                      icon:
                                          Icon(Icons.highlight_remove_outlined),
                                      onPressed: () {
                                        setState(() {
                                          showdateRange = false;
                                          searchController.text = "";
                                          dateRange = null;
                                          getChangedList("");
                                        });
                                      })
                                ],
                              ),
                            )),
                    Flexible(
                      flex: 2,
                      child: IconButton(
                        icon: Icon(Icons.date_range_outlined,
                            size: 30, color: FlavorConfig.instance.color),
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                              initialEntryMode: DatePickerEntryMode.calendar,
                              firstDate: DateTime(2021),
                              context: context,
                              currentDate: DateTime.now(),
                              lastDate: DateTime.now());
                          if (picked != null) {
                            print(picked);
                            setState(() {
                              showdateRange = true;
                              dateRange = picked;
                              meterReadingList = null;
                            });
                            print(DateFormat("dd-MM-yyyy")
                                    .format(picked.start) +
                                " " +
                                DateFormat("dd-MM-yyyy").format(picked.end));
                            meterReadingList =
                                await dbRef.getMeterReadingsByDate(
                                    DateFormat("yyyy-MM-dd")
                                        .format(picked.start),
                                    DateFormat("yyyy-MM-dd")
                                        .format(picked.end));
                            setState(() {});
                          }
                          print(picked.start.toString() +
                              " - " +
                              picked.end.toString());
                        },
                      ),
                    )
                  ]),
                  meterReadingList != null
                      ? meterReadingList.length > 0
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: meterReadingList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //   return ListTile(
                                  //       leading: Card(
                                  //           elevation: 3,
                                  //           child: CircleAvatar(
                                  //               radius: 10,
                                  //               backgroundColor: Colors.white,
                                  //               backgroundImage: FileImage(
                                  //                   File(consumerPhotos[index])),
                                  //               child: null)));
                                  return Card(
                                      shadowColor: meterReadingList[index]
                                                  .uploadStatus ==
                                              "No"
                                          ? Colors.green
                                          : Colors.grey[350],
                                      semanticContainer: false,
                                      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                      color: meterReadingList[index]
                                                  .uploadStatus ==
                                              "No"
                                          ? Colors.green[100]
                                          : Colors.white,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ListTile(
                                        title: Text(
                                            meterReadingList[index]
                                                .consumerName,
                                            textAlign: TextAlign.left,
                                            style: greenStyle().copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        subtitle: Row(
                                          children: [
                                            Text(
                                                'Mtr. No. : ' +
                                                    meterReadingList[index]
                                                        .meterNumber
                                                        .toString(),
                                                textAlign: TextAlign.left,
                                                style: greenStyle().copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                'Mtr. Reading. : ' +
                                                    meterReadingList[index]
                                                        .meterReading
                                                        .toString(),
                                                textAlign: TextAlign.left,
                                                style: greenStyle().copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                )),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete_outline),
                                          onPressed: () async {
                                            showConfirmDialog(
                                                "Confirm",
                                                "Are you sure you want to delete this record permanently ?",
                                                "Cancel",
                                                "Delete", () {
                                              Navigator.pop(this.context);
                                            }, () async {
                                              print(
                                                  "i clicked delete button => " +
                                                      meterReadingList[index]
                                                          .id
                                                          .toString());
                                              dbRef.deleteConnection(
                                                  meterReadingList[index].id);
                                              meterReadingList = null;
                                              meterReadingList = await dbRef
                                                  .getMeterReadingsList();
                                              meterReadingCount =
                                                  meterReadingList.length;
                                              setState(() {});
                                              Navigator.pop(this.context);
                                            });
                                          },
                                        ),
                                        leading: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            elevation: 10,
                                            child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: Colors.white,
                                                backgroundImage: FileImage(File(
                                                    meterReadingList[index]
                                                        .consumerPhoto)),
                                                child: null)),
                                      )

                                      // ExpansionTile(
                                      //   tilePadding:
                                      //       EdgeInsets.symmetric(horizontal: 5),
                                      //   // backgroundColor: uploadStatusList[index] == "No"
                                      //   //     ? Colors.lightGreen
                                      //   //     : Colors.white,
                                      //   // title: FittedBox(
                                      //   //   fit: BoxFit.scaleDown,
                                      //   //   alignment: Alignment.centerLeft,
                                      //   title: Text(
                                      //       meterReadingList[index].consumerName,
                                      //       textAlign: TextAlign.left,
                                      //       style: greenStyle().copyWith(
                                      //         fontSize: 18,
                                      //         fontWeight: FontWeight.bold,
                                      //       )),
                                      //   // ),
                                      //   leading: Card(
                                      //       shape: RoundedRectangleBorder(
                                      //           borderRadius:
                                      //               BorderRadius.circular(25)),
                                      //       elevation: 10,
                                      //       child: CircleAvatar(
                                      //           radius: 25,
                                      //           backgroundColor: Colors.white,
                                      //           backgroundImage: FileImage(File(
                                      //               meterReadingList[index]
                                      //                   .consumerPhoto)),
                                      //           child: null)),
                                      //   trailing: meterReadingList[index]
                                      //               .uploadStatus ==
                                      //           "No"
                                      //       ? Row(
                                      //           mainAxisSize: MainAxisSize.min,
                                      //           children: [
                                      //               IconButton(
                                      //                 icon: Icon(
                                      //                     Icons.delete_outline),
                                      //                 onPressed: () async {
                                      //                   showConfirmDialog(
                                      //                       "Confirm",
                                      //                       "Are you sure you want to delete this record permanently ?",
                                      //                       "Cancel",
                                      //                       "Delete", () {
                                      //                     Navigator.pop(
                                      //                         this.context);
                                      //                   }, () async {
                                      //                     print("i clicked delete button => " +
                                      //                         meterReadingList[
                                      //                                 index]
                                      //                             .id
                                      //                             .toString());
                                      //                     dbRef.deleteConnection(
                                      //                         meterReadingList[
                                      //                                 index]
                                      //                             .id);
                                      //                     meterReadingList = null;
                                      //                     meterReadingList =
                                      //                         await dbRef
                                      //                             .getMeterReadingsList();
                                      //                     meterReadingCount =
                                      //                         meterReadingList
                                      //                             .length;
                                      //                     setState(() {});
                                      //                     Navigator.pop(
                                      //                         this.context);
                                      //                   });
                                      //                 },
                                      //               )
                                      //             ])
                                      //       : null,
                                      //   children: [],
                                      // ),

                                      );
                                },
                              ),
                            )
                          : Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "No Entries yet !!",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )),
                                ],
                              ),
                            )
                      : Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              SpinKitRing(
                                lineWidth: 3,
                                color: Colors.green[900],
                                size: 40.0,
                                duration: Duration(milliseconds: 1000),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Loading...",
                                // style: regularTxtStyle,
                              )
                            ])),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }

  Widget internalDetails(String fieldName, String fieldValue) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              //   margin: EdgeInsets.fromLTRB(25, 5, 15, 5),
              // width: 100,
              child: Text(fieldName,
                  textAlign: TextAlign.center, style: greenStyle())),
          Container(
              //   margin: EdgeInsets.fromLTRB(0, 5, 25, 5),
              alignment: Alignment.centerLeft,
              child: Text(fieldValue,
                  textAlign: TextAlign.left, style: blackStyle()))
        ],
      ),
    );
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

  void showConfirmDialog(String title, String message, String btn1Text,
      String btn2Text, Function function1, Function function2) {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            new OutlineButton(
              borderSide: BorderSide(color: Colors.blue),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textColor: Colors.blue,
              child: new Text(btn1Text),
              onPressed: function1,
            ),
            new OutlineButton(
              borderSide: BorderSide(color: Colors.red),
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textColor: Colors.red,
              child: new Text(btn2Text),
              onPressed: function2,
            ),
          ],
        );
      },
    );
  }

  void submitDetails() async {
    String url =
        FlavorConfig.instance.url() + "/MeterConnections/addMultiConnection";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var connectlist = await dbRef.getMeterReadingsByStatus("No");

    List<Map<String, dynamic>> connections = List<Map<String, dynamic>>();

    for (var connection in connectlist) {
      final Map<String, dynamic> data = {
        "name": connection.consumerName,
        "createdBy": SessionData().data.id,
        "address": connection.consumerAddress,
        "meter_reading": connection.meterReading,
        "meter_number": connection.meterNumber,
        "lat": connection.latitude,
        "lang": connection.longitude,
        "branchId": SessionData().data.branchId,
        "media": await MultipartFile.fromFile(connection.consumerPhoto,
            filename: File(connection.consumerPhoto).path.split("/").last)
      };
      connections.add(data);
    }

    print("this is connection list => " + connections.toString());

    FormData formData = FormData.fromMap({"data": connections});

    print(formData.fields);

    if (connections.length > 0) {
      setState(() {
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
              print(response.data["message"]);
              dbRef.updateMeterReading();
              meterReadingList = null;
              getDbList();
              showDialogOnError("Successful", response.data["message"], "Ok",
                  () {
                Navigator.of(this.context).pop();
              });
            } else if (response.statusCode == 403) {
              print(response.data);
              showInFlushBar(
                  context, response.data[0]["message"], _scaffoldKey);
              SessionData().settoken(response.data[0]["new-token"]);
              print(SessionData().data.token);
              // showDialogOnError(this.context, "Session Timeout",
              //     "Your session has expired", "Retry", isEmpty);
            }
          } else {
            setState(() {
              _isLoading = false;
            });
            print(response.statusMessage);
          }
        });
      } on DioError catch (e) {
        print("this is status code submit => " +
            e.response.statusCode.toString());
        print("this is status code submit => " + e.response.statusMessage);
        print("this is data error => " + e.response.data.toString());
        if (e.response.statusCode == 403) {
          setState(() {
            _isLoading = false;
          });
          print("this is error => " + e.response.data[0]["message"]);
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
          setState(() {
            _isLoading = false;
          });
          showInFlushBar(
              this.context, e.response.data[0]["message"], _scaffoldKey);
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showDialogOnError("Empty", "No offline data available to upload", "Ok",
          () {
        Navigator.pop(this.context);
      });
    }
  }
}
