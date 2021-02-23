import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('about_us'),
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
          backgroundColor: Colors.red,
          elevation: 0.0,
          actions: [],
        ),
        body: Stack(
          children: [


            
            Positioned(
                bottom: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.4,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/images/a.png",
                    fit: BoxFit.fitWidth,
                  ),
                ))
          ],
        ));
  }
}
