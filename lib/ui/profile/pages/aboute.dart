import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('about_us'),
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
        actions: [],
      ),
      body: Container(),
    );
  }
}
