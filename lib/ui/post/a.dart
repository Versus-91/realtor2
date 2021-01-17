import 'dart:convert';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _chosenValue;
 
  void _showDecline() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return AlertDialog(
            title: new Text("Decline Appointment Request"),
            content: Container(
              height: 100,
              width: 200,
              child: Column(
                children: <Widget>[
                  new Text("لطفا گزینه مورد نظر خود را وارد کنید."),
                  new DropdownButton<String>(
                    hint: Text('Select one option'),
                    value: _chosenValue,
                    underline: Container(),
                    items: <String>[
                      'I\'m not able to help',
                      'Unclear description',
                      'Not available at set date and time',
                      'Other'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _chosenValue = value;
                      });
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
          },
                  
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
              child: Container(
          child: FlatButton(child: Text('Click'), onPressed: _showDecline),
        ),
      ),
    );
  }
}

