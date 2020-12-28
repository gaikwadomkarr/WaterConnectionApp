import 'package:flutter/material.dart';

class AddConnectionPage extends StatefulWidget {
  AddConnectionPage({Key key}) : super(key: key);

  @override
  _AddConnectionPageState createState() => _AddConnectionPageState();
}

class _AddConnectionPageState extends State<AddConnectionPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("Add Connection"), backgroundColor: Colors.green[900]),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Column(children: [buildDropdownButtonFormField()]),
        )),
      ),
    );
  }

  DropdownButtonFormField<String> buildDropdownButtonFormField() {
    return DropdownButtonFormField(
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2))),
        items: <String>['A', 'B', 'C', 'D'].map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (_) {});
  }
}
