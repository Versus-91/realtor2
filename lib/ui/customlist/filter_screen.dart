import 'dart:convert';

import 'package:boilerplate/main.dart';
import 'package:boilerplate/stores/category/category_store.dart';
import 'package:boilerplate/stores/city/city_store.dart';
import 'package:boilerplate/stores/district/district_store.dart';
import 'package:boilerplate/stores/form/filter_form.dart';
import 'package:boilerplate/stores/form/post_form.dart';
import 'package:boilerplate/stores/type/type_store.dart';

import 'package:boilerplate/ui/customlist/silder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'list_theme.dart';
import 'model/pop_list.dart';
import 'model/suggestion.dart';
import 'package:http/http.dart' as http;

class FiltersScreen extends StatefulWidget {
  final FilterFormStore filterForm;
  FiltersScreen({@required this.filterForm});
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

enum SelectType { Rent, Buy }
enum SelectTypeHome { Maskoni, Tejari, Sanati }

class _FiltersScreenState extends State<FiltersScreen> {
  List<SelectedPropertyTypes> popularFilterListData =
      SelectedPropertyTypes.popularFList;
  List<int> selectedTypes = [];
  List<SelectedPropertyTypes> accomodationListData;
  int _value;
  final _controller = TextEditingController();
  bool searching = true, error;
  var data;
  String query;
  String dataurl =
      "http://hmahmudi-001-site2.gtempurl.com/api/services/app/District/Find";
  CityStore _cityStore;
  DistrictStore _districtStore;
  CategoryStore _categoryStore;
  TypeStore _typeStore;
  String _categoryText = '';

  SelectTypeHome _hometype = SelectTypeHome.Maskoni;
  final _store = PostFormStore(appComponent.getRepository());
  final List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    accomodationListData = widget.filterForm.selectedPropertyTypes;
    _cityStore = Provider.of<CityStore>(context);
    _districtStore = Provider.of<DistrictStore>(context);
    _categoryStore = Provider.of<CategoryStore>(context);
    _typeStore = Provider.of<TypeStore>(context);

    if (!_cityStore.loading) _cityStore.getCities();
    if (!_districtStore.loading) _districtStore.getDistricts();
    if (!_categoryStore.loading) _categoryStore.getCategories();
    if (!_typeStore.loading) _typeStore.getTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
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
                      onPressed: () {
                        var items = accomodationListData
                            ?.where((item) =>
                                item.id != null && item.isSelected == true)
                            ?.toList();
                        if (items != null && items.length > 0) {
                          for (var type in items) {
                            widget.filterForm.setPropertyType(type.id);
                          }
                        }
                        widget.filterForm
                            .setPropertyTypeList(accomodationListData);
                        widget.filterForm.loading = true;
                        Future.delayed(Duration(milliseconds: 2), () {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                )
              ],
            )),
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    searching ? searchField() : Text('data'),
                    _buildCategoryField(),
                    const Divider(
                      height: 1,
                    ),
                    //_buildHomeTypeField(),
                    const Divider(
                      height: 1,
                    ),
                    priceBarFilter(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: const Divider(
                        height: 1,
                      ),
                    ),
                    popularFilter(),
                    const Divider(
                      height: 1,
                    ),
                    _buildBedroomCountField(),
                    const Divider(
                      height: 1,
                    ),
                    distanceViewUI(),
                    const Divider(
                      height: 1,
                    ),
                    allAccommodationUI()
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryField() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Observer(
        builder: (context) {
          return _categoryStore.categoryList != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                        _categoryStore.categoryList.categories.length,
                        (index) {
                          var category =
                              _categoryStore.categoryList.categories[index];
                          if (_value == null) {
                            _value = category.id;
                            var _categoryText = category.name;
                            _store.setCategory(category.id);
                          }
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _categoryText = category.name;
                                  _value = category.id;
                                });
                                _categoryText = category.name;
                                _store.setCategory(category.id);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: _value == category.id
                                      ? Border(
                                          bottom: BorderSide(
                                              width: 2.0,
                                              color: Colors.redAccent),
                                        )
                                      : Border(
                                          bottom: BorderSide(
                                              width: 2.0,
                                              color: Colors.transparent),
                                        ),
                                ),
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: _value == category.id
                                          ? Colors.redAccent
                                          : Colors.black),
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    )
                  ],
                )
              : Container(
                  child: FlatButton(
                      onPressed: () {
                        _categoryStore.getCategories();
                      },
                      child: Icon(Icons.refresh)),
                );
        },
      ),
    );
  }

  Widget showSearchSuggestions() {
    List<SearchSuggestion> suggestionlist =
        List<SearchSuggestion>.from(data["data"].map((i) {
      return SearchSuggestion.fromJSON(i);
    }));
    //serilizing json data inside model list.
    return Column(
      children: suggestionlist.map((suggestion) {
        return InkResponse(
            onTap: () {
              //when tapped on suggestion
              print(suggestion.id); //pint student id
            },
            child: SizedBox(
                width: double.infinity, //make 100% width
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      suggestion.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )));
      }).toList(),
    );
  }

  Widget searchField() {
    //search input field
    return Container(
        padding: EdgeInsets.all(20),
        child: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.redAccent, fontSize: 18),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.red, fontSize: 18),
            hintText: "جستجوی مکان",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ), //under line border, set OutlineInputBorder() for all side border
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ), // focused border color
          ), //decoration for search input field
          onChanged: (value) {
            query = value; //update the value of query
            getSuggestion(); //start to get suggestion
          },
        ));
  }

  void getSuggestion() async {
    //get suggestion function
    var res = await http.post(dataurl + "?query=" + Uri.encodeComponent(query));
    //in query there might be unwant character so, we encode the query to url
    if (res.statusCode == 200) {
      setState(() {
        data = json.decode(res.body);
        //update data value and UI
      });
    } else {
      //there is error
      setState(() {
        error = true;
      });
    }
  }

  Widget allAccommodationUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'نوع ملک',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.red,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Observer(builder: (context) {
          if (accomodationListData.length > 1) {
            return Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Column(
                children: getAccomodationListUI(),
              ),
            );
          }
          if (_typeStore.typeList != null) {
            if (accomodationListData.length == 0) {
              accomodationListData = _typeStore.typeList.types
                  .map((item) => SelectedPropertyTypes(
                      isSelected: false, titleTxt: item.name, id: item.id))
                  .toList();
              accomodationListData.insert(
                  0,
                  SelectedPropertyTypes(
                    titleTxt: 'همه موارد',
                    isSelected: false,
                  ));
            }

            return Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Column(
                children: getAccomodationListUI(),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(70),
              child: Column(
                children: [
                  new CircularProgressIndicator(),
                  new Text("Loading"),
                ],
              ),
            );
          }
        }),
      ],
    );
  }

  List<Widget> getAccomodationListUI() {
    final List<Widget> noList = <Widget>[];

    for (int i = 0; i < accomodationListData.length; i++) {
      final SelectedPropertyTypes date = accomodationListData[i];
      noList.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            onTap: () {
              setState(() {
                checkAppPosition(i);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      date.titleTxt,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: date.isSelected
                        ? HotelAppTheme.buildLightTheme().primaryColor
                        : Colors.grey.withOpacity(0.6),
                    onChanged: (bool value) {
                      setState(() {
                        checkAppPosition(i);
                      });
                    },
                    value: date.isSelected,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      if (i == 0) {
        noList.add(const Divider(
          height: 1,
        ));
      }
    }
    return noList;
  }

  void checkAppPosition(int index) {
    if (index == 0) {
      if (accomodationListData[0].isSelected) {
        accomodationListData.forEach((d) {
          d.isSelected = false;
        });
      } else {
        accomodationListData.forEach((d) {
          d.isSelected = true;
        });
      }
    } else {
      accomodationListData[index].isSelected =
          !accomodationListData[index].isSelected;

      int count = 0;
      for (int i = 0; i < accomodationListData.length; i++) {
        if (i != 0) {
          final SelectedPropertyTypes data = accomodationListData[i];
          if (data.isSelected) {
            count += 1;
          }
        }
      }

      if (count == accomodationListData.length - 1) {
        accomodationListData[0].isSelected = true;
      } else {
        accomodationListData[0].isSelected = false;
      }
    }
  }

  Widget distanceViewUI() {
    return Observer(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: Text(
              'مساحت',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SliderView(
            distValue: widget.filterForm.area ?? 100,
            onChangedistValue: (double value) {
              widget.filterForm.setArea(value);
            },
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      );
    });
  }

  Widget popularFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'فیلتر بر اساس :',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.red,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPList() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < popularFilterListData.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final SelectedPropertyTypes date = popularFilterListData[count];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        date.isSelected = !date.isSelected;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            date.isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: date.isSelected
                                ? HotelAppTheme.buildLightTheme().primaryColor
                                : Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            date.titleTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          if (count < popularFilterListData.length - 1) {
            count += 1;
          } else {
            break;
          }
        } catch (e) {
          throw (e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Widget _buildHomeTypeField() {
    return Observer(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: SelectTypeHome.Tejari,
                groupValue: _hometype,
                onChanged: (SelectTypeHome value) {
                  _hometype = value;
                  setState(() {
                    var typehome = int.tryParse(value.toString());
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
                  });
                },
              ),
              new Text(
                'صنعتی',
                style: new TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBedroomCountField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "تعداد اتاق :",
            style: TextStyle(color: Colors.red[300]),
            textAlign: TextAlign.right,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ToggleButtons(
                children: <Widget>[
                  Text("+1"),
                  Text("+2"),
                  Text("+3"),
                  Text("+4"),
                  Text("+5"),
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
      ),
    );
  }

  Widget priceBarFilter() {
    return Observer(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "قیمت",
              style: TextStyle(color: Colors.red),
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
    });
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'فیلتر',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}
