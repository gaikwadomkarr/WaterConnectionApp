import 'dart:io';

import 'package:flutter/material.dart';
import 'package:waterconnection/UI/AddConnectionPage.dart';
import 'package:waterconnection/UI/AllEntriesScreen.dart';
import 'package:waterconnection/UI/LoginScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> screens = [AddConnectionPage(), AllEntriesScreen()];
  int _selectedIndex = 0;

  void comfirmExitFromUser() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: new Text(
          'Are you sure?',
        ),
        content: new Text('Do you want to exit an app'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              exit(0);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print(_selectedIndex);
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        } else {
          comfirmExitFromUser();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
            // type: BottomNavigationBarType.shifting,
            elevation: 1.0,
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            selectedItemColor: Colors.green[900],
            unselectedItemColor: Colors.black54,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline_rounded),
                label: 'Connection',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                label: 'Entries',
              )
            ],

            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
          body: screens[_selectedIndex],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
