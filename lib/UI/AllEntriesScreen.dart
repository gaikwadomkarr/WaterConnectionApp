import 'package:flutter/material.dart';

class AllEntriesScreen extends StatefulWidget {
  @override
  _AllEntriesScreenState createState() => _AllEntriesScreenState();
}

class _AllEntriesScreenState extends State<AllEntriesScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              title: Text("All Entries"),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: null)
              ],
              backgroundColor: Colors.green[900]),
          body: Container(
            child: Center(
                child: Text(
              "Coming Soon...",
              style: TextStyle(fontSize: 20),
            )),
          ),
        ),
      ),
    );
  }
}
