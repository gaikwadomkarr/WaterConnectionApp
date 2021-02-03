import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterconnection/Helpers/FlavConfig.dart';
import 'package:waterconnection/Helpers/NetworkHelprs.dart';
import 'package:waterconnection/Helpers/SessionData.dart';
import 'package:waterconnection/Helpers/WaterConnectionDBHelper.dart';
import 'package:waterconnection/Models/ConnectionDB.dart';
import 'package:waterconnection/UI/LoginScreen.dart';

class AllEntriesPage extends StatefulWidget {
  @override
  _AllEntriesPageState createState() => _AllEntriesPageState();
}

class _AllEntriesPageState extends State<AllEntriesPage> {
  SharedPreferences prefs;
  int connectionCount = 0;
  bool _isLoading = false;
  bool showCrossMark = false;
  bool showdateRange = false;
  DateTimeRange dateRange;
  TextEditingController searchController = new TextEditingController();
  final dbRef = WaterConnectionDBHelper();
  List<ConnectionDb> connectionList;
  List<String> consumerNames = List<String>();
  List<String> consumerPhotos = List<String>();
  List<String> contractorNames = List<String>();
  List<String> zonesList = List<String>();
  List<String> addressList = List<String>();
  List<String> mobileNumbersList = List<String>();
  List<String> saddlesList = List<String>();
  List<String> ferruleList = List<String>();
  List<String> roadCrossingList = List<String>();
  List<String> mdpePipeList = List<String>();
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

  void getDbList() async {
    connectionList = await dbRef.getConnections();
    connectionCount = connectionList.length;
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
                      connectionList = null;
                    });
                    connectionList = await dbRef.getConnections();
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
    connectionList = null;
    connectionList = await dbRef.getConnectionsByName(name);
    setState(() {});
  }

  void getEntries() async {
    prefs = await SharedPreferences.getInstance();
    consumerNames = prefs.getStringList("consumerNamesList") ?? [];
    consumerPhotos = prefs.getStringList("consumerPhotosList") ?? [];
    contractorNames = prefs.getStringList("contractorList") ?? [];
    zonesList = prefs.getStringList("zonesList") ?? [];
    addressList = prefs.getStringList("addressList") ?? [];
    mobileNumbersList = prefs.getStringList("consumermobileList") ?? [];
    saddlesList = prefs.getStringList("saddlesList") ?? [];
    ferruleList = prefs.getStringList("ferruleList") ?? [];
    roadCrossingList = prefs.getStringList("roadCrossingList") ?? [];
    mdpePipeList = prefs.getStringList("mdpePipeList") ?? [];
    connectionCount = consumerNames.length ?? 0;
    uploadStatusList = prefs.getStringList("uploadStatusList") ?? [];
    connectionDates = prefs.getStringList("connectionDates") ?? [];
    consumerlat = prefs.getStringList("consumerlat") ?? [];
    consumerlang = prefs.getStringList("consumerlang") ?? [];
    setState(() {});
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
                title: Text("All Entries ($connectionCount)"),
                actions: [
                  IconButton(
                      icon: Icon(Icons.cloud_upload_outlined),
                      onPressed: () async {
                        submitDetails();
                      }),
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
                              connectionList = null;
                            });
                            connectionList = await dbRef.getConnectionsByDate(
                                DateFormat("dd-MM-yyyy").format(picked.start),
                                DateFormat("dd-MM-yyyy").format(picked.end));
                            setState(() {});
                          }
                          print(picked.start.toString() +
                              " - " +
                              picked.end.toString());
                        },
                      ),
                    )
                  ]),
                  connectionList != null
                      ? connectionList.length > 0
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: connectionList.length,
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
                                    shadowColor:
                                        connectionList[index].uploadStatus ==
                                                "No"
                                            ? Colors.green
                                            : Colors.grey[350],
                                    semanticContainer: false,
                                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    color: connectionList[index].uploadStatus ==
                                            "No"
                                        ? Colors.green[100]
                                        : Colors.white,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ExpansionTile(
                                      tilePadding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      // backgroundColor: uploadStatusList[index] == "No"
                                      //     ? Colors.lightGreen
                                      //     : Colors.white,
                                      // title: FittedBox(
                                      //   fit: BoxFit.scaleDown,
                                      //   alignment: Alignment.centerLeft,
                                      title: Text(
                                          connectionList[index].consumerName,
                                          textAlign: TextAlign.left,
                                          style: greenStyle().copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      // ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              connectionList[index]
                                                      .consumerMobile ??
                                                  "--",
                                              style: greenStyle()
                                                  .copyWith(fontSize: 13)),
                                          Text(
                                            connectionList[index].createdAt ??
                                                "-",
                                            style: blackStyle().copyWith(
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
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
                                                  connectionList[index]
                                                      .consumerPhoto)),
                                              child: null)),
                                      trailing: connectionList[index]
                                                  .uploadStatus ==
                                              "No"
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.delete_outline),
                                                    onPressed: () async {
                                                      print(
                                                          "i clicked delete button => " +
                                                              connectionList[
                                                                      index]
                                                                  .id
                                                                  .toString());
                                                      dbRef.deleteConnection(
                                                          connectionList[index]
                                                              .id);
                                                      connectionList = null;
                                                      connectionList =
                                                          await dbRef
                                                              .getConnections();
                                                      connectionCount =
                                                          connectionList.length;
                                                      setState(() {});
                                                    },
                                                  )
                                                ])
                                          : null,
                                      children: [
                                        internalDetails("Contractor",
                                            connectionList[index].contractor),
                                        internalDetails(
                                            "Zone", connectionList[index].zone),
                                        internalDetails("Saddle",
                                            connectionList[index].saddle),
                                        internalDetails(
                                            "Ferrule",
                                            (connectionList[index].ferrule ==
                                                    "1")
                                                ? "Yes"
                                                : "No"),
                                        internalDetails(
                                            "Road Crossing",
                                            (connectionList[index]
                                                        .roadCrossing ==
                                                    "1"
                                                ? "Yes"
                                                : "No")),
                                        internalDetails(
                                            "Mdpe Pipe",
                                            connectionList[index]
                                                    .mdpePipeLength +
                                                " mtrs")
                                      ],
                                    ),
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

  void submitDetails() async {
    String url = FlavorConfig.instance.url() + "/Consumer/addMultiConnection";

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var connectlist = await dbRef.getConnectionsByStatus("No");

    List<Map<String, dynamic>> connections = List<Map<String, dynamic>>();

    for (var connection in connectlist) {
      final Map<String, dynamic> data = {
        "name": connection.consumerName,
        "createdBy": SessionData().data.id,
        "address": connection.consumerAddress,
        "contractorId": connection.contractorId,
        "zoneId": connection.zoneId,
        "saddleId": connection.saddleId,
        "isFerrule": connection.ferrule == "Yes" ? 1 : 0,
        "isRoadCrossing": connection.roadCrossing == "Yes" ? 1 : 0,
        "pipeSize": connection.mdpePipeLength,
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
              dbRef.updateConnection();
              connectionList = null;
              getDbList();
              showDialogOnError(
                  this.context, "Successful", response.data["message"], "Ok",
                  () {
                Navigator.pop(this.context);
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
          showDialogOnError(this.context, "Session Timeout",
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
      showDialogOnError(
          this.context, "Empty", "No offline data available to upload", "Ok",
          () {
        Navigator.pop(this.context);
      });
    }
  }
}
