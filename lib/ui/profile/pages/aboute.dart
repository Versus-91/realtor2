import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.all(4),
            children: <Widget>[
              ///Menu Mode with no searchBox

              ///BottomSheet Mode with no searchBox
              Row(
                children: [
                  Flexible(
                    child: DropdownSearch<String>(
                      mode: Mode.MENU,
                      maxHeight: 300,
                      items: ["Brazil", "Italia", "Tunisia", 'Canada'],
                      label: "شهر",
                      onChanged: print,
                      selectedItem: "Brazil",
                      showSearchBox: true,
                      autoFocusSearchBox: true,
                      searchBoxDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                        labelText: "Search a country",
                      ),
                      popupShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(),
                  Flexible(
                    child: DropdownSearch<String>(
                      mode: Mode.MENU,
                      maxHeight: 300,
                      items: ["Brazil", "Italia", "Tunisia", 'Canada'],

                      label: "منطقه",
                      onChanged: print,
                      selectedItem: "Brazil",
                      // showSelectedItem: true,
                      showSearchBox: true,
                      autoFocusSearchBox: true,
                      searchBoxDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                        labelText: "جست و جوی منطقه",
                      ),
                      popupShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(),
                  Flexible(
                    child: DropdownSearch<String>(
                      mode: Mode.MENU,
                      maxHeight: 300,
                      items: ["Brazil", "Italia", "Tunisia", 'Canada'],
                      label: "ناحیه",
                      onChanged: print,
                      selectedItem: "Brazil",
                      showSearchBox: true,
                      autoFocusSearchBox: true,
                      searchBoxDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                        labelText: "Search a country",
                      ),
                      popupShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
