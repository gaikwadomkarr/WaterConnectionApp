import 'package:flutter/material.dart';
import 'package:waterconnection/UI/AddConnectionPage.dart';
import 'package:waterconnection/UI/LoginScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> screens = [AddConnectionPage(), LoginScreen()];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: screens[_selectedIndex],
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
