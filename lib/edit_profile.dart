import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "پروفایل",
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: new EditProfileScreen(),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  @override
  State createState() => new EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  File avatarImageFile, backgroundImageFile;
  String sex;

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;

   
    Column(
      children: <Widget>[ 
         Container(
      width: double.infinity,
      height: 200.0,
    ),

        // Username
        new Container(
          child: new Text(
            'Username',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.amber),
          ),
          margin: new EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
        ),
        new Container(
          child: new TextFormField(
            decoration: new InputDecoration(
                hintText: 'Tran Quang Duy',
                border: new UnderlineInputBorder(),
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: new TextStyle(color: Colors.grey)),
          ),
          margin: new EdgeInsets.only(left: 30.0, right: 30.0),
        ),

        // Country
        new Container(
          child: new Text(
            'Country',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.amber),
          ),
          margin: new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
        ),
        new Container(
          child: new TextFormField(
            decoration: new InputDecoration(
                hintText: 'Viet Nam',
                border: new UnderlineInputBorder(),
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: new TextStyle(color: Colors.grey)),
          ),
          margin: new EdgeInsets.only(left: 30.0, right: 30.0),
        ),

        // Address
        new Container(
          child: new Text(
            'Address',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.amber),
          ),
          margin: new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
        ),
        new Container(
          child: new TextFormField(
            decoration: new InputDecoration(
                hintText: '320/12 Trường Chinh, HCM',
                border: new UnderlineInputBorder(),
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: new TextStyle(color: Colors.grey)),
          ),
          margin: new EdgeInsets.only(left: 30.0, right: 30.0),
        ),

        // About me
        new Container(
          child: new Text(
            'About me',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.amber),
          ),
          margin: new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
        ),
        new Container(
          child: new TextFormField(
            decoration: new InputDecoration(
                hintText: 'Fun, like travel, read book and play PES!!!',
                border: new UnderlineInputBorder(),
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: new TextStyle(color: Colors.grey)),
          ),
          margin: new EdgeInsets.only(left: 30.0, right: 30.0),
        ),

        // About me
        new Container(
          child: new Text(
            'Phone',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.amber),
          ),
          margin: new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
        ),
        new Container(
          child: new TextFormField(
            decoration: new InputDecoration(
                hintText: '0123456789',
                border: new UnderlineInputBorder(),
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: new TextStyle(color: Colors.grey)),
            keyboardType: TextInputType.number,
          ),
          margin: new EdgeInsets.only(left: 30.0, right: 30.0),
        ),

        // Sex
        new Container(
          child: new Text(
            'Sex',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.amber),
          ),
          margin: new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
        ),
        new Container(
          child: new DropdownButton<String>(
            items: <String>['Male', 'Female'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                sex = value;
              });
            },
            hint: sex == null
                ? new Text('Male')
                : new Text(
                    sex,
                    style: new TextStyle(color: Colors.black),
                  ),
            style: new TextStyle(color: Colors.black),
          ),
          margin: new EdgeInsets.only(left: 50.0),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );

   
  }
}

