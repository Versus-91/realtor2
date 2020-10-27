

import 'package:boilerplate/main.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/city/city_store.dart';
import 'package:boilerplate/stores/district/district_store.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';

import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/city/city.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

enum SelectType { Rent, Buy }
enum SelectTypeHome { Maskoni, Tejari, Sanati }

class _SearchScreenState extends State<SearchScreen> {
  int selectedItem;

  int _value = 1;
  final List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  var citiesList = new List<City>();
  final List<String> maskonibranch = <String>[
    'سوییت',
    'زمین',
    'آپارتمان',
    'کلنگی',
    'ویلایی',
    'مشارکتی'
  ];

  //text controllers:-----------------------------------------------------------
  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  
  // TextEditingController _rahnPriceController = TextEditingController();
  // TextEditingController _rentPriceController = TextEditingController();
  // TextEditingController _buyPriceController = TextEditingController();
  // TextEditingController _rangeAreaController = TextEditingController();
  // TextEditingController _bedroomCountController = TextEditingController();

  //stores:---------------------------------------------------------------------
  ThemeStore _themeStore;
  CityStore _cityStore;
  DistrictStore _districtStore;
  SelectType _character = SelectType.Buy;
  SelectTypeHome _hometype = SelectTypeHome.Maskoni;
  //focus node:-----------------------------------------------------------------

  //stores:---------------------------------------------------------------------
  final _store = FormStore(appComponent.getRepository());

  @override
  void initState() {
    super.initState();
  }

 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _themeStore = Provider.of<ThemeStore>(context);
    _cityStore = Provider.of<CityStore>(context);
    _districtStore = Provider.of<DistrictStore>(context);
    if (!_cityStore.loading) _cityStore.getCities();
    if (!_districtStore.loading) _districtStore.getDistricts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    height: 50,
                    child: FlatButton(
                        splashColor: Colors.red,
                        color: Colors.red[100],
                        onPressed: () {},
                        child: Text(
                          "پاک کردن گزینه ها",
                          style: TextStyle(color: Colors.grey[600]),
                        )),
                  )),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  height: 50,
                  child: FlatButton.icon(
                    color: Colors.red,
                    splashColor: Colors.red[100],
                    icon: const Icon(FontAwesomeIcons.search, size: 18),
                    label: Text("جست و جو",
                        style: TextStyle(color: Colors.grey[900])),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          )),
    );
  }

  // app bar methods:-----------------------------------------------------------
  Widget _buildAppBar() {
    return AppBar(
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.settings),
        )
      ],
      title: Text(AppLocalizations.of(context).translate('home_tv_search')),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Material(
        child: Stack(
          children: <Widget>[
            MediaQuery.of(context).orientation == Orientation.landscape
                ? Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: _buildLeftSide(),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildRightSide(),
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      _buildRightSide(),
                    ],
                  ),
            Observer(
              builder: (context) {
                return _store.success
                    ? navigate(context)
                    : _showErrorMessage(_store.errorStore.errorMessage);
              },
            ),
            Observer(
              builder: (context) {
                return Visibility(
                  visible: _store.loading,
                  child: CustomProgressIndicatorWidget(),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSide() {
    return SizedBox.expand(
        // child: Image.asset(
        //   Assets.carBackground,
        //   fit: BoxFit.cover,
        // ),
        );
  }

  Widget _buildRightSide() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         
          // SizedBox(height: 40.0),
          _buildTitleField(),
          Divider(
            color: Colors.grey,
          ),
          Row(
            children: <Widget>[
              _buildCitylistField(),
              _buildDistrictlistField(),
            ],
          ),

          _buildHomeTypeField(),
          if (_hometype == SelectTypeHome.Maskoni) _buildmaskonibranchField(),
        
          if (_character == SelectType.Rent) ...[
            _buildRentPriceField(),
            _buildEjarePriceField(),
          ],
          if (_character == SelectType.Buy) _buildBuyPriceField(),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _buildRangeAreaField(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _buildBedroomCountField(),
          ),
        ],
      ),
    );
  }

  _buildmaskonibranchField() {
    return Wrap(
      children: List<Widget>.generate(
        6,
        (int index) {
          return ChoiceChip(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
            // shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
            label: Text(maskonibranch[index]),
            selected: _value == index,
            onSelected: (bool selected) {
              setState(() {
                _value = selected ? index : null;
              });
            },
          );
        },
      ).toList(),
    );
  }

  
  Widget _buildRangeAreaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "متراژ(متر مربع)",
          style: TextStyle(color: Colors.red[300]),
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'پایین ترین متراژ',
                ),
              ),
            ),
            Text("_"),
            Flexible(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'بالا ترین متراژ',
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildRentPriceField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("رهن"),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "پایین ترین رهن",
                        contentPadding: EdgeInsets.all(10))),
              ),
              Text("_"),
              Flexible(
                child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "بالا ترین رهن",
                        contentPadding: EdgeInsets.all(10))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEjarePriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("اجاره"),
        Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "پایین ترین اجاره",
                      contentPadding: EdgeInsets.all(10))),
            ),
            Text("_"),
            Flexible(
              child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "بالا ترین اجاره",
                      contentPadding: EdgeInsets.all(10))),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBuyPriceField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "قیمت",
            style: TextStyle(color: Colors.red[300]),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "پایین ترین قیمت",
                        contentPadding: EdgeInsets.all(10))),
              ),
              Text("_"),
              Flexible(
                child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "بالا ترین قیمت",
                        contentPadding: EdgeInsets.all(10))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictlistField() {
    return Observer(
      builder: (context) {
        return _districtStore.districtList != null
            ? Container(
                padding: EdgeInsets.only(top: 10, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "موقعیت",
                      style: TextStyle(color: Colors.red[300]),
                    ),
                    Row(
                      children: <Widget>[
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                              labelText: "منطقه",
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 4)),
                          onChanged: (int val) => setState(() => {
                                selectedItem = val,
                              }),
                          items:
                              _districtStore.districtList.districts.map((item) {
                            return DropdownMenuItem<int>(
                              child: Text(item.name),
                              value: item.id,
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  ],
                ),
              )
            : Container(
                child: Text("مشکل اتصال"),
              );
      },
    );

    //
  }

  Widget _buildCitylistField() {
    return Observer(
      builder: (context) {
        return _cityStore.cityList != null
            ? Container(
                padding: EdgeInsets.only(top: 10, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "موقعیت",
                      style: TextStyle(color: Colors.red[300]),
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                                labelText: "شهر",
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 4)),
                            onChanged: (int val) => setState(() => {
                                  selectedItem = val,
                                }),
                            items: _cityStore.cityList.cities.map((item) {
                              return DropdownMenuItem<int>(
                                child: Text(item.name),
                                value: item.id,
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    )
                  ],
                ),
              )
            : Container(
                child: Text("nist"),
              );
      },
    );
  }

  Widget _buildTitleField() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Observer(
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: SelectType.Buy,
                groupValue: _character,
                onChanged: (SelectType value) {
                  _character = value;
                  setState(() {
                    var typeId = int.tryParse(value.toString());
                    _store.setUserType(typeId);
                  });
                },
              ),
              Text(
                'خرید',
                style: TextStyle(fontSize: 16.0),
              ),
              Radio(
                value: SelectType.Rent,
                groupValue: _character,
                onChanged: (SelectType value) {
                  _character = value;
                  setState(() {
                    var typeId = int.tryParse(value.toString());
                    _store.setUserType(typeId);
                  });
                },
              ),
              Text(
                'رهن و اجاره',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHomeTypeField() {
    return Observer(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "نوع ملک",
              style: TextStyle(color: Colors.red[300]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                  value: SelectTypeHome.Tejari,
                  groupValue: _hometype,
                  onChanged: (SelectTypeHome value) {
                    _hometype = value;
                    setState(() {
                      var typehome = int.tryParse(value.toString());
                      _store.setTypeHome(typehome);
                    });
                  },
                ),
                Text(
                  'تجاری',
                  style: TextStyle(fontSize: 16.0),
                ),
                Radio(
                  value: SelectTypeHome.Maskoni,
                  groupValue: _hometype,
                  onChanged: (SelectTypeHome value) {
                    _hometype = value;
                    setState(() {
                      var typehome = int.tryParse(value.toString());
                      _store.setTypeHome(typehome);
                    });
                  },
                ),
                Text(
                  'مسکونی',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Radio(
                  value: SelectTypeHome.Sanati,
                  groupValue: _hometype,
                  onChanged: (SelectTypeHome value) {
                    _hometype = value;
                    setState(() {
                      var typehome = int.tryParse(value.toString());
                      _store.setTypeHome(typehome);
                    });
                  },
                ),
                new Text(
                  'صنعتی',
                  style: new TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBedroomCountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "تعداد اتاق :",
          style: TextStyle(color: Colors.red[300]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ToggleButtons(
              children: <Widget>[
                Text("1"),
                Text("2"),
                Text("3"),
                Text("4"),
                Text("5"),
                Text("6"),
                Text("7"),
                Text("8"),
                Text("9"),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: isSelected,
            ),
          ),
        ),
      ],
    );
  }

  Widget navigate(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home, (Route<dynamic> route) => false);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message != null && message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _titleController.dispose();
    _locationController.dispose();
    // _rahnPriceController.dispose();
    // _rentPriceController.dispose();
    // _buyPriceController.dispose();
    // _rangeAreaController.dispose();
    // _bedroomCountController.dispose();

    super.dispose();
  }
}
