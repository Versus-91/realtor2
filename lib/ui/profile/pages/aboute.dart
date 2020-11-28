
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('about_us'),
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
        actions: [],
      ),
      body: Container(),
    );
  }
}
