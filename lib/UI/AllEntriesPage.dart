import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterconnection/Helpers/NetworkHelprs.dart';
import 'package:waterconnection/UI/LoginScreen.dart';

class AllEntriesPage extends StatefulWidget {
  @override
  _AllEntriesPageState createState() => _AllEntriesPageState();
}

class _AllEntriesPageState extends State<AllEntriesPage> {
  SharedPreferences prefs;
  int connectionCount = 0;
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

  @override
  void initState() {
    super.initState();
    getEntries();
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
              child: consumerNames.length > 0
                  ? Container(
                      child: ListView.builder(
                        itemCount: consumerNames.length,
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
                          return Container(
                            margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ExpansionTile(
                                backgroundColor: uploadStatusList[index] == "No"
                                    ? Colors.lightGreen
                                    : Colors.white,
                                title: Text(
                                  consumerNames[index],
                                  style: greenStyle().copyWith(fontSize: 15),
                                ),
                                subtitle: Text(mobileNumbersList[index] ?? "--",
                                    style: greenStyle().copyWith(fontSize: 13)),
                                leading: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    elevation: 10,
                                    child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white,
                                        backgroundImage: FileImage(
                                            File(consumerPhotos[index])),
                                        child: null)),
                                children: [
                                  internalDetails(
                                      "Contractor", contractorNames[index]),
                                  internalDetails("Zone", zonesList[index]),
                                  internalDetails("Saddle", saddlesList[index]),
                                  internalDetails(
                                      "Ferrule",
                                      (ferruleList[index] == "1")
                                          ? "Yes"
                                          : "No"),
                                  internalDetails(
                                      "Road Crossing",
                                      (roadCrossingList[index] == "1")
                                          ? "Yes"
                                          : "No"),
                                  internalDetails("Mdpe Pipe",
                                      mdpePipeList[index] + " mtrs")
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(child: Text("No Entries yet !!"))),
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
}
