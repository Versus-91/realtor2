import 'dart:convert';
import 'package:boilerplate/stores/area/area_store.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/models/amenity/amenity.dart';
import 'package:boilerplate/models/category/category.dart';
import 'package:boilerplate/models/location/locations.dart';
import 'package:boilerplate/models/post/post_request.dart';
import 'package:boilerplate/models/type/type.dart';
import 'package:boilerplate/stores/amenity/amenity_store.dart';
import 'package:boilerplate/stores/category/category_store.dart';
import 'package:boilerplate/stores/city/city_store.dart';
import 'package:boilerplate/stores/district/district_store.dart';
import 'package:boilerplate/stores/form/filter_form.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/type/type_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'list_theme.dart';

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
  int _value;
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _minAreaController = TextEditingController();
  final TextEditingController _maxAreaController = TextEditingController();
  final TextEditingController _minDepositController = TextEditingController();
  final TextEditingController _maxDepositController = TextEditingController();
  // final TextEditingController _minRentController = TextEditingController();
  final TextEditingController _maxRentController = TextEditingController();

  final _minRentController = TextEditingController();
  String _selectedCity;
  var data;
  String dataurl = Endpoints.baseUrl + "/api/services/app/District/Find";
  CityStore _cityStore;
  AreaStore _areaStore;
  DistrictStore _districtStore;
  CategoryStore _categoryStore;
  TypeStore _typeStore;
  AmenityStore _amenityStore;
  String cityDropdownValue;
  String localityDropdownValue;
  final List<bool> isSelected = [
    false,
    false,
    false,
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
    _cityStore = Provider.of<CityStore>(context);
    _districtStore = Provider.of<DistrictStore>(context);
    _areaStore = Provider.of<AreaStore>(context);
    _categoryStore = Provider.of<CategoryStore>(context);
    _typeStore = Provider.of<TypeStore>(context);
    _amenityStore = Provider.of<AmenityStore>(context);

    if (!_cityStore.loading && _cityStore.cityList == null)
      _cityStore.getCities();
    if (!_districtStore.loading && _districtStore.districtList == null)
      _districtStore.getDistricts();
    if (!_areaStore.loading && _areaStore.areaList == null)
      _areaStore.getAreas();
    if (!_categoryStore.loading && _categoryStore.categoryList == null)
      _categoryStore.getCategories();
    if (!_typeStore.loading && _typeStore.typeList == null)
      _typeStore.getTypes();
    if (!_amenityStore.loading && _amenityStore.amenityList == null)
      _amenityStore.getAmenities();

    _typeAheadController.text = widget.filterForm?.district?.name == null
        ? widget.filterForm?.city?.name
        : widget.filterForm.district.name;
    if (widget.filterForm?.bedCount != null) {
      isSelected[widget.filterForm.bedCount - 1] = true;
    }

    if (widget.filterForm.minPrice != null) {
      _minPriceController.text = widget.filterForm.minPrice.toString();
    }
    if (widget.filterForm.maxPrice != null) {
      _maxPriceController.text = widget.filterForm.maxPrice.toString();
    }
    if (widget.filterForm.minArea != null) {
      _minAreaController.text = widget.filterForm.minArea.toString();
    }
    if (widget.filterForm.maxArea != null) {
      _maxAreaController.text = widget.filterForm.maxArea.toString();
    }
    if (widget.filterForm.minDepositPrice != null) {
      _minDepositController.text = widget.filterForm.minDepositPrice.toString();
    }
    if (widget.filterForm.maxDepositPrice != null) {
      _maxDepositController.text = widget.filterForm.maxDepositPrice.toString();
    }
    if (widget.filterForm.minRentPrice != null) {
      _minRentController.text = widget.filterForm.minRentPrice.toString();
    }
    if (widget.filterForm.maxRentPrice != null) {
      _maxRentController.text = widget.filterForm.maxRentPrice.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
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
                      color: Colors.white,
                    ),
                    label: Text(
                        AppLocalizations.of(context).translate('search'),
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onPressed: () {
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          reverse: false,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: <Widget>[
                getAppBarUI(),
                searchField(),
                SizedBox(height: 10),
                _buildCitylistField(),
                SizedBox(height: 10),
                Row(
                  children: [
                    _buildArealistField(),
                    VerticalDivider(),
                    _buildDistrictlistField(),
                  ],
                ),
                _buildCategoryField(),
                popularFilter(),
                _buildBedroomCountField(),
                areaViewUI(AppLocalizations.of(context).translate('area')),
                propertyTypes()
              ],
            ),
          ),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List<Widget>.generate(
                          _categoryStore.categoryList.categories.length,
                          // برای اینکه یکی از کتگوری ها انتخاب بشه

                          (index) {
                            var category =
                                _categoryStore.categoryList.categories[index];
                            _value = widget.filterForm.category.id;
                            if (_value == null &&
                                !category.name.contains('گروی')) {
                              _value = category.id;
                              widget.filterForm
                                  .setCategory(category.id, category.name);
                            }
                            return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: chipOne(category.name, () {
                                  if (_value != category.id) {
                                    setState(() {
                                      _value = category.id;
                                      resetPrice(category);
                                    });
                                  }
                                  widget.filterForm
                                      .setCategory(category.id, category.name);
                                },
                                    active:
                                        _value == category.id ? true : false));
                          },
                        ).toList(),
                      ),
                    ),
                    if (widget.filterForm.category.name.contains(
                      AppLocalizations.of(context).translate('rahn'),
                    )) ...[
                      depositPriceBarFilter(
                          AppLocalizations.of(context).translate('rahn_scope')),
                      rentPriceBarFilter(
                          AppLocalizations.of(context).translate('rent_scope')),
                    ],
                    if (widget.filterForm.category.name.contains(
                      AppLocalizations.of(context).translate('rent'),
                    )) ...[
                      Row(
                        children: [
                          Flexible(
                              child: rentPriceBarFilter(
                                  AppLocalizations.of(context)
                                      .translate('rent_scope'))),
                        ],
                      ),
                    ],
                    if (widget.filterForm.category.name.contains(
                      AppLocalizations.of(context).translate('buy'),
                    )) ...[
                      priceBarFilter(
                          AppLocalizations.of(context).translate('price_scope'))
                    ],
                  ],
                )
              : Opacity(
                  opacity: 0.8,
                  child: Shimmer.fromColors(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              "کرای",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "معاوضه",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "گروی",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "خرید و فروش",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ]),
                    baseColor: Colors.black12,
                    highlightColor: Colors.white,
                    loop: 3,
                  ),
                );
        },
      ),
    );
  }

  void resetPrice(Category category) {
    if (category.name.contains("گروی")) {
      widget.filterForm.resetPrice();

      _minPriceController.clear();
      _maxPriceController.clear();
    } else {
      widget.filterForm.resetPrice();

      _minDepositController.clear();
      _maxDepositController.clear();
      _minRentController.clear();
      _maxRentController.clear();
    }
  }

  Widget chipOne(String title, Function clickAction, {bool active = false}) {
    //active argument is optional
    return Container(
        color: Colors.transparent,
        margin: EdgeInsets.all(5),
        child: FlatButton(
            color: active ? Colors.green[200] : Colors.white,
            //if active == true then background color is black
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(color: Colors.grey, width: 1)
                //set border radius, color and width
                ),
            onPressed: clickAction, //set function
            child: Text(title) //set title
            ));
  }

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 14, right: 14),
      child: Container(
        height: 55,
        child: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      widget.filterForm.setDistrict(null, null);
                      widget.filterForm.setCity(null, null);
                      widget.filterForm.setArea(null, null);
                      _typeAheadController.clear();
                    },
                    icon: _typeAheadController.text != null
                        ? Icon(Icons.clear)
                        : Icon(Icons.search)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                labelText: AppLocalizations.of(context)
                    .translate('search_in_district'),
                fillColor: Color(0xfff3f3f4),
                filled: true,
                hintText: AppLocalizations.of(context)
                    .translate('search_in_district')),
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
            return Container(
              height: 45,
              child: Padding(
                padding: EdgeInsets.only(top: 5, right: 10),
                child: Text(
                  AppLocalizations.of(context).translate('no_result'),
                  style: TextStyle(fontSize: 20, color: Colors.grey[400]),
                ),
              ),
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
          onSaved: (value) {
            return this._selectedCity = value;
          },
        ),
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

  Widget propertyTypes() {
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
            return Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Column(
                children: getAccomodationListUI(_typeStore.typeList.types),
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

  List<Widget> getAccomodationListUI(List<Type> types) {
    final List<Widget> noList = <Widget>[];

    for (int i = 0; i < types.length; i++) {
      final Type propertyType = types[i];
      var isPropertySelected = widget.filterForm.propertyTypes
          .firstWhere((m) => m == propertyType.id, orElse: () => null);
      noList.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            onTap: () {
              widget.filterForm.setPropertyType(propertyType.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      propertyType.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: isPropertySelected != null
                        ? HotelAppTheme.buildLightTheme().primaryColor
                        : Colors.grey.withOpacity(0.6),
                    onChanged: (bool value) {
                      widget.filterForm.setPropertyType(propertyType.id);
                    },
                    value: isPropertySelected != null,
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

  Widget areaViewUI(String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize:
                            MediaQuery.of(context).size.width > 360 ? 18 : 16,
                        fontWeight: FontWeight.normal),
                  ),
                  Text(
                    AppLocalizations.of(context).translate('area_range'),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize:
                            MediaQuery.of(context).size.width > 360 ? 13 : 13,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                          controller: _minAreaController,
                          onChanged: (value) {
                            widget.filterForm.setLowArea(double.parse(value));
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              labelText: AppLocalizations.of(context)
                                  .translate('low_area'),
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                              hintText: AppLocalizations.of(context)
                                  .translate('low_area'),
                              contentPadding: EdgeInsets.all(10))),
                    ),
                    VerticalDivider(),
                    Flexible(
                      child: TextField(
                          controller: _maxAreaController,
                          onChanged: (value) {
                            widget.filterForm.setHightArea(double.parse(value));
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                              labelText: AppLocalizations.of(context)
                                  .translate('hight_area'),
                              hintText: AppLocalizations.of(context)
                                  .translate('hight_area'),
                              contentPadding: EdgeInsets.all(10))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // SliderView(
        //   distValue: widget.filterForm.area ?? 100,
        //   onChangedistValue: (double value) {
        //     widget.filterForm.setArea(value);
        //   },
        // ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget popularFilter() {
    return Observer(builder: (context) {
      if (_amenityStore.amenityList != null) {
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
                children: getPList(_amenityStore.amenityList.amenities),
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

  List<Widget> getPList(List<Amenity> amenities) {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < amenities.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final Amenity amenity = amenities[count];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      widget.filterForm.setAmenity(amenity.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            widget.filterForm.amenities.firstWhere(
                                        (m) => m == amenity.id,
                                        orElse: () => null) !=
                                    null
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: widget.filterForm.amenities.firstWhere(
                                        (m) => m == amenity.id,
                                        orElse: () => null) !=
                                    null
                                ? HotelAppTheme.buildLightTheme().primaryColor
                                : Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            amenity.name,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          if (count < amenities.length - 1) {
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

  Widget _buildCitylistField() {
    return Observer(
      builder: (context) {
        if (_cityStore.cityList != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 0, left: 14, right: 14),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                maxHeight: 300,
                items: _cityStore.cityList.cities
                    .map((city) => city.name)
                    .toList(),
                isFilteredOnline: true,
                label: "شهر",
                onChanged: (String val) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  if (val != cityDropdownValue) {
                    setState(() {
                      cityDropdownValue = val;
                    });

                    _areaStore.getAreasByCityid(_cityStore.cityList.cities
                        .firstWhere((city) => city.name == cityDropdownValue)
                        ?.id);
                  }
                },
                selectedItem: cityDropdownValue,
                showSearchBox: true,
                autoFocusSearchBox: true,
                searchBoxDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                  labelText: "جست و جو شهر",
                ),
                popupShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Opacity(
            opacity: 0.8,
            child: Shimmer.fromColors(
              child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('city'),
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  )),
              baseColor: Colors.black12,
              highlightColor: Colors.white,
              loop: 30,
            ),
          );
        }
      },
    );
  }

  Widget _buildArealistField() {
    return Observer(
      builder: (context) {
        if (_areaStore.areaList != null && cityDropdownValue != null) {
          return Flexible(
            child: _areaStore.loading == true
                ? LinearProgressIndicator()
                : (_areaStore.areaList.areas.length > 0
                    ? Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Container(
                          height: 50,
                          child: DropdownSearch<String>(
                            mode: Mode.MENU,
                            maxHeight: 300,
                            items: _areaStore.areaList.areas
                                .map((area) => area.name)
                                .toList(),
                            isFilteredOnline: true,
                            label: "ناحیه",
                            onChanged: (String val) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              if (val != localityDropdownValue) {
                                setState(() {
                                  // _store.setLocality(int.parse(val));
                                  localityDropdownValue = val;
                                });
                                _districtStore.getDistrictsByAreaid(_areaStore
                                    .areaList.areas
                                    .firstWhere((area) =>
                                        area.name == localityDropdownValue)
                                    ?.id);
                              }
                            },
                            selectedItem: localityDropdownValue,
                            showSearchBox: true,
                            autoFocusSearchBox: true,
                            searchBoxDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                              labelText: "جست و جو ناحیه",
                            ),
                            popupShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context).translate('notfound_area'),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )),
          );
        } else {
          return Flexible(
            child: Opacity(
              opacity: 0.8,
              child: Shimmer.fromColors(
                child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 15, right: 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('locality'),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    )),
                baseColor: Colors.black12,
                highlightColor: Colors.white,
                loop: 30,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildDistrictlistField() {
    return Observer(
      builder: (context) {
        if (_districtStore.districtList != null &&
            localityDropdownValue != null) {
          return Flexible(
            child: _districtStore.loading == true
                ? LinearProgressIndicator()
                : (_districtStore.districtList.districts.length > 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 0, left: 14),
                        child: Container(
                          height: 50,
                          child: DropdownSearch<String>(
                            mode: Mode.MENU,
                            maxHeight: 300,
                            items: _districtStore.districtList.districts
                                .map((district) => district.name)
                                .toList(),
                            isFilteredOnline: true,
                            label: "محله",
                            onChanged: (String val) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              int selectDistrict = _districtStore
                                  .districtList.districts
                                  .firstWhere(
                                      (district) => district.name == val)
                                  .id;

                              // _store.setDistrict(selectDistrict);
                            },
                            selectedItem: "محله",
                            showSearchBox: true,
                            autoFocusSearchBox: true,
                            searchBoxDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                              labelText: "جست و جو محله",
                            ),
                            popupShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)
                            .translate('notfound_district'),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )),
          );
        } else {
          return Flexible(
            child: Opacity(
              opacity: 0.8,
              child: Shimmer.fromColors(
                child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 15),
                    child: Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('district'),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    )),
                baseColor: Colors.black12,
                highlightColor: Colors.white,
                loop: 30,
              ),
            ),
          );
        }
      },
    );

    //
  }

  Widget _buildBedroomCountField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('count_room'),
            style: TextStyle(
                color: Colors.red,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  children: <Widget>[
                    Text(
                      "+" +
                          AppLocalizations.of(context)
                              .transformNumbers(0.toString()),
                    ),
                    Text(
                      "+" +
                          AppLocalizations.of(context)
                              .transformNumbers(1.toString()),
                    ),
                    Text(
                      "+" +
                          AppLocalizations.of(context)
                              .transformNumbers(2.toString()),
                    ),
                    Text(
                      "+" +
                          AppLocalizations.of(context)
                              .transformNumbers(3.toString()),
                    ),
                    Text(
                      "+" +
                          AppLocalizations.of(context)
                              .transformNumbers(4.toString()),
                    ),
                    Text(
                      "+" +
                          AppLocalizations.of(context)
                              .transformNumbers(5.toString()),
                    ),
                    Text(
                      "+" +
                          AppLocalizations.of(context)
                              .transformNumbers(10.toString()),
                    ),
                    Text(
                      "+" +
                          AppLocalizations.of(context)
                              .transformNumbers(20.toString()),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < isSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          if (isSelected[buttonIndex] != true) {
                            isSelected[buttonIndex] = true;
                            widget.filterForm.setBedCount(index);
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
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                AppLocalizations.of(context).translate('currency_type'),
                style: TextStyle(
                    color: Colors.red,
                    fontSize: MediaQuery.of(context).size.width > 360 ? 13 : 13,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                      controller: _minPriceController,
                      onChanged: (value) {
                        widget.filterForm.setMinPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          labelText: AppLocalizations.of(context)
                              .translate('lowest_price'),
                          hintText: AppLocalizations.of(context)
                              .translate('lowest_price'),
                          contentPadding: EdgeInsets.all(10))),
                ),
                VerticalDivider(),
                Flexible(
                  child: TextField(
                      controller: _maxPriceController,
                      onChanged: (value) {
                        widget.filterForm.setMaxPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          labelText: AppLocalizations.of(context)
                              .translate('highest_price'),
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
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                AppLocalizations.of(context).translate('currency_type'),
                style: TextStyle(
                    color: Colors.red,
                    fontSize: MediaQuery.of(context).size.width > 360 ? 13 : 13,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                      controller: _minRentController,
                      onChanged: (value) {
                        widget.filterForm.setMinRentPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          fillColor: Color(0xfff3f3f4),
                          labelText: AppLocalizations.of(context)
                              .translate('lowest_price'),
                          filled: true,
                          hintText: AppLocalizations.of(context)
                              .translate('lowest_price'),
                          contentPadding: EdgeInsets.all(10))),
                ),
                VerticalDivider(),
                Flexible(
                  child: TextField(
                      controller: _maxRentController,
                      onChanged: (value) {
                        widget.filterForm.setMaxRentPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          labelText: AppLocalizations.of(context)
                              .translate('highest_price'),
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
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                AppLocalizations.of(context).translate('currency_type'),
                style: TextStyle(
                    color: Colors.red,
                    fontSize: MediaQuery.of(context).size.width > 360 ? 13 : 13,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                      controller: _minDepositController,
                      onChanged: (value) {
                        widget.filterForm
                            .setMinDepositPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          labelText: AppLocalizations.of(context)
                              .translate('lowest_price'),
                          hintText: AppLocalizations.of(context)
                              .translate('lowest_price'),
                          contentPadding: EdgeInsets.all(10))),
                ),
                VerticalDivider(),
                Flexible(
                  child: TextField(
                      controller: _maxDepositController,
                      onChanged: (value) {
                        widget.filterForm
                            .setMaxDepositPrice(double.parse(value));
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          fillColor: Color(0xfff3f3f4),
                          labelText: AppLocalizations.of(context)
                              .translate('highest_price'),
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
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
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
