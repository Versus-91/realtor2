import 'dart:convert';
import 'package:boilerplate/models/location/locations.dart';
import 'package:boilerplate/models/post/post_request.dart';
import 'package:boilerplate/stores/amenity/amenity_store.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:boilerplate/stores/category/category_store.dart';
import 'package:boilerplate/stores/city/city_store.dart';
import 'package:boilerplate/stores/district/district_store.dart';
import 'package:boilerplate/stores/form/filter_form.dart';
import 'package:boilerplate/stores/type/type_store.dart';

import 'package:boilerplate/ui/search/silder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'list_theme.dart';
import 'model/pop_list.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final FilterFormStore filterForm;
  final PostStore postStore;
  SearchScreen({this.filterForm, this.postStore});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  PostRequest _filterRequest;
  List<dynamic> _locations;
  List<int> selectedTypes = [];
  List<SelectedPropertyTypes> accomodationListData = [];
  List<SelectedPropertyTypes> amenityList = [];
  int _value;
  final TextEditingController _typeAheadController = TextEditingController();
  String _selectedCity;
  var data;
  String dataurl =
      "http://hmahmudi-001-site2.gtempurl.com/api/services/app/District/Find";
  CityStore _cityStore;
  DistrictStore _districtStore;
  CategoryStore _categoryStore;
  TypeStore _typeStore;
  AmenityStore _amenityStore;
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
    _amenityStore = Provider.of<AmenityStore>(context);

    if (!_cityStore.loading && _cityStore.cityList == null)
      _cityStore.getCities();
    if (!_districtStore.loading && _districtStore.districtList == null)
      _districtStore.getDistricts();
    if (!_categoryStore.loading && _categoryStore.categoryList == null)
      _categoryStore.getCategories();
    if (!_typeStore.loading && _typeStore.typeList == null)
      _typeStore.getTypes();
    if (!_amenityStore.loading && _amenityStore.amenityList == null)
      _amenityStore.getAmenities();
    _typeAheadController.text = widget.filterForm.district.name == null
        ? widget.filterForm.city.name
        : widget.filterForm.district.name;
    if (widget.filterForm.bedCount != null) {
      isSelected[widget.filterForm.bedCount - 1] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 50,
                  child: FlatButton.icon(
                    color: Colors.red,
                    splashColor: Colors.red[100],
                    icon: const Icon(
                      FontAwesomeIcons.search,
                      size: 18,
                      color: Colors.blueGrey,
                    ),
                    label: Text(
                        AppLocalizations.of(context).translate('search'),
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      widget.filterForm
                          .setPropertyTypeList(accomodationListData);
                      _filterRequest = widget.filterForm.applyFilters();
                      if (_filterRequest != null) {
                        widget.postStore.getPosts(request: _filterRequest);
                      }
                      Future.delayed(Duration(milliseconds: 2), () {
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
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
                    searchField(),
                    _buildCategoryField(),
                    popularFilter(),
                    _buildBedroomCountField(),
                    distanceViewUI(),
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
      padding: const EdgeInsets.only(bottom: 10),
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
                          _value = widget.filterForm.category.id;
                          if (_value == null &&
                              !category.name.contains('اجاره')) {
                            _value = category.id;
                            widget.filterForm
                                .setCategory(category.id, category.name);
                          }
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _value = category.id;
                                });
                                widget.filterForm
                                    .setCategory(category.id, category.name);
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
                    ),
                    if (widget.filterForm.category.name != null &&
                        widget.filterForm.category.name.contains(
                          AppLocalizations.of(context).translate('rent'),
                        )) ...{
                      Column(
                        children: [
                          depositPriceBarFilter(AppLocalizations.of(context)
                              .translate('rahn_scope')),
                          rentPriceBarFilter(AppLocalizations.of(context)
                              .translate('rent_scope'))
                        ],
                      )
                    } else ...{
                      priceBarFilter(
                          AppLocalizations.of(context).translate('price_scope'))
                    }
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

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 14, right: 14),
      child: TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    widget.filterForm.setDistrict(null, null);
                    widget.filterForm.setCity(null, null);
                    _typeAheadController.clear();
                  },
                  icon: Icon(Icons.clear)),
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              hintText:
                  AppLocalizations.of(context).translate('search_in_district')),
          controller: this._typeAheadController,
        ),
        suggestionsCallback: (pattern) {
          if (pattern.trim().length >= 2 && pattern.trim() != _selectedCity) {
            return getSuggestion(pattern);
          }
          return null;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        noItemsFoundBuilder: (context) {
          return Text(
            AppLocalizations.of(context).translate('no_result'),
            style: TextStyle(fontSize: 30, color: Colors.grey[300]),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          this._typeAheadController.text = suggestion;
          var selectedLocation = _locations
              .where((element) => suggestion.contains(element.name))
              ?.first;
          if (selectedLocation != null) {
            if (selectedLocation.isCity) {
              widget.filterForm.setDistrict(null, null);
              widget.filterForm.setCity(selectedLocation.id, suggestion);
            } else {
              widget.filterForm.setCity(null, null);
              widget.filterForm.setDistrict(selectedLocation.id, suggestion);
            }
          }
        },
        validator: (value) => value.isEmpty
            ? AppLocalizations.of(context).translate('insert_district')
            : null,
        onSaved: (value) => this._selectedCity = value,
      ),
    );
  }

  Future<List> getSuggestion(String pattern) async {
    //get suggestion function
    var res =
        await http.post(dataurl + "?query=" + Uri.encodeComponent(pattern));
    //in query there might be unwant character so, we encode the query to url
    if (res.statusCode == 200) {
      setState(() {
        data = json.decode(res.body)["result"];
        _locations = data
            .map((item) => Location(
                name: item["name"], id: item["id"], isCity: item["isCity"]))
            .toList();
        data = data.map((item) {
          var locationLabel = item["isCity"] == true
              ? AppLocalizations.of(context).translate('district')
              : AppLocalizations.of(context).translate('city');
          return locationLabel + " " + item["name"];
        }).toList();
        //update data value and UI
      });
    }
    return data.toList();
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
            AppLocalizations.of(context).translate('type_home'),
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.red,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Observer(builder: (context) {
          if (_typeStore.typeList != null) {
            if (accomodationListData.length == 0) {
              accomodationListData = _typeStore.typeList.types
                  .map((item) => SelectedPropertyTypes(
                      isSelected: false, titleTxt: item.name, id: item.id))
                  .toList();
              accomodationListData.insert(
                  0,
                  SelectedPropertyTypes(
                    titleTxt:
                        AppLocalizations.of(context).translate('all_cases'),
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
            return Container(
              child: Center(
                child: new Text(
                    AppLocalizations.of(context).translate('nofilter')),
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
    return Observer(builder: (context) {
      if (_amenityStore.amenityList != null) {
        if (amenityList.length == 0) {
          amenityList = _amenityStore.amenityList.amenities
              .map((item) => SelectedPropertyTypes(
                    id: item.id,
                    titleTxt: item.name,
                    isSelected: widget.filterForm.amenities
                            .where((m) => m == item.id)
                            .isNotEmpty
                        ? true
                        : false,
                  ))
              .toList();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 8),
              child: Text(
                AppLocalizations.of(context).translate('amenities'),
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
      } else {
        return SizedBox.shrink();
      }
    });
  }

  List<Widget> getPList() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < amenityList.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final SelectedPropertyTypes amenity = amenityList[count];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        amenity.isSelected = !amenity.isSelected;
                        widget.filterForm.setAmenity(amenity.id);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            amenity.isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: amenity.isSelected
                                ? HotelAppTheme.buildLightTheme().primaryColor
                                : Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            amenity.titleTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          if (count < amenityList.length - 1) {
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

  Widget _buildBedroomCountField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('count'),
            style: TextStyle(
                color: Colors.red,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
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
                        if (isSelected[buttonIndex] != true) {
                          isSelected[buttonIndex] = true;
                          widget.filterForm.setBedCount(index + 1);
                        } else {
                          isSelected[buttonIndex] = false;
                          widget.filterForm.setBedCount(null);
                        }
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
                isSelected: isSelected,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget priceBarFilter(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
                color: Colors.red,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                      onChanged: (value) {
                        widget.filterForm.setMinPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          hintText: AppLocalizations.of(context)
                              .translate('lowest_price'),
                          contentPadding: EdgeInsets.all(10))),
                ),
                VerticalDivider(),
                Flexible(
                  child: TextField(
                      onChanged: (value) {
                        widget.filterForm.setMaxPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          hintText: AppLocalizations.of(context)
                              .translate('highest_price'),
                          contentPadding: EdgeInsets.all(10))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rentPriceBarFilter(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
                color: Colors.red,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                      onChanged: (value) {
                        widget.filterForm.setMinRentPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          hintText: AppLocalizations.of(context)
                              .translate('lowest_price'),
                          contentPadding: EdgeInsets.all(10))),
                ),
                VerticalDivider(),
                Flexible(
                  child: TextField(
                      onChanged: (value) {
                        widget.filterForm.setMaxRentPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          hintText: AppLocalizations.of(context)
                              .translate('highest_price'),
                          contentPadding: EdgeInsets.all(10))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget depositPriceBarFilter(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
                color: Colors.red,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                      onChanged: (value) {
                        widget.filterForm
                            .setMinDepositPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          hintText: AppLocalizations.of(context)
                              .translate('lowest_price'),
                          contentPadding: EdgeInsets.all(10))),
                ),
                VerticalDivider(),
                Flexible(
                  child: TextField(
                      onChanged: (value) {
                        // widget.filterForm
                        //     .setMaxdepositPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          hintText: AppLocalizations.of(context)
                              .translate('highest_price'),
                          contentPadding: EdgeInsets.all(10))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
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
                  AppLocalizations.of(context).translate('filter'),
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
