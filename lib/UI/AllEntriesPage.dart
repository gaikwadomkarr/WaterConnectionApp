import 'dart:io';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
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
    print("this is uploadStatus => " + connectionList[0].uploadStatus);
    setState(() {});
  }

  Widget buildSearchbar() {
    return Container(
      height: 45,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.green, blurRadius: 5, offset: Offset(0, 1))
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      child: TextFormField(
        // enabled: !_isDialogShowing,
        decoration: new InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            size: 30,
            color: FlavorConfig.instance.color,
          ),
          hintText: "Start typing to see Contact list",
          enabledBorder: InputBorder.none,
          counterText: "",
          hintStyle: blackStyle().copyWith(color: Colors.black54),
        ),
        controller: searchController,
        onChanged: (value) {
          print("Print onChange value $value");
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
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              title: Text("All Entries ($connectionCount)"),
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
          body: Center(
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Flexible(flex: 1, child: buildSearchbar())]),
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
                                  margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  color:
                                      connectionList[index].uploadStatus == "No"
                                          ? Colors.green[100]
                                          : Colors.white,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ExpansionTile(
                                    tilePadding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    // backgroundColor: uploadStatusList[index] == "No"
                                    //     ? Colors.lightGreen
                                    //     : Colors.white,
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          connectionList[index].consumerName,
                                          style: greenStyle()
                                              .copyWith(fontSize: 15),
                                        ),
                                      ],
                                    ),
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
                                    trailing:
                                        connectionList[index].uploadStatus ==
                                                "No"
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons.delete_outline),
                                                      onPressed: () {
                                                        print(
                                                            "i clicked upload button");
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
                                      internalDetails("Ferrule",
                                          connectionList[index].ferrule),
                                      internalDetails("Road Crossing",
                                          connectionList[index].roadCrossing),
                                      internalDetails(
                                          "Mdpe Pipe",
                                          connectionList[index].mdpePipeLength +
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
                                    child: Text("No Entries yet !!")),
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

  void submitDetails(int index) async {
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
      "name": consumerNames[index],
      "createdBy": SessionData().data.id,
      "address": addressList[index],
      "contractorId": int.parse(contractorNames[index].split(",").last),
      "zoneId": int.parse(zonesList[index].split(",").last),
      "saddleId": int.parse(saddlesList[index].split(",").last),
      "isFerrule": ferruleList[index] == "Yes" ? 1 : 0,
      "isRoadCrossing": roadCrossingList[index] == "Yes" ? 1 : 0,
      "pipeSize": mdpePipeList[index],
      "lat": consumerlat[index],
      "lang": consumerlang[index],
      "branchId": SessionData().data.branchId,
      "media": await MultipartFile.fromFile(consumerPhotos[index],
          filename: File(consumerPhotos[index]).path.split("/").last)
    });

    print(formData.fields);

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

            showDialogOnError(
                this.context, "Successful", response.data["message"], "Ok", () {
              Navigator.pop(this.context);
            });
          } else if (response.statusCode == 403) {
            print(response.data);
            showInFlushBar(context, response.data[0]["message"], _scaffoldKey);
            SessionData().settoken(response.data[0]["new-token"]);
            print(SessionData().data.token);
            // showDialogOnError(this.context, "Session Timeout",
            //     "Your session has expired", "Retry", isEmpty);
          }
        } else {
          print(response.statusMessage);
        }
      });
    } on DioError catch (e) {
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
          submitDetails(index);

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
