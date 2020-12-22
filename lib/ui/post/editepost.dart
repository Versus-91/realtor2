import 'dart:async';
import 'dart:io';

import 'package:boilerplate/main.dart';
import 'package:boilerplate/models/amenity/amenity.dart';
import 'package:boilerplate/models/category/category.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/amenity/amenity_store.dart';
import 'package:boilerplate/stores/category/category_store.dart';
import 'package:boilerplate/stores/city/city_store.dart';
import 'package:boilerplate/stores/district/district_store.dart';
import 'package:boilerplate/stores/form/post_form.dart';
import 'package:boilerplate/stores/type/type_store.dart';
import 'package:boilerplate/ui/post/user_map_screen.dart';
import 'package:boilerplate/ui/search/model/pop_list.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flushbar/flushbar_route.dart' as route;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class EditPostScreen extends StatefulWidget {
  EditPostScreen({this.post});

  final Post post;
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  int selectedItem;
  int cityDropdownValue;
  int _value;
  String _categoryText = '';
  String _fileName;
  List<PlatformFile> _paths;
  String _extension;
  bool _multiPick = true;
  bool hasErrorInloading = false;
  FileType _pickingType = FileType.image;
  List<SelectedPropertyTypes> amenityList = [];
  TextEditingController _controller = TextEditingController();
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

  //text controllers:-----------------------------------------------------------
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _rahnPriceController = TextEditingController();
  TextEditingController _rentPriceController = TextEditingController();
  TextEditingController _buyPriceController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _bedroomCountController = TextEditingController();

  //stores:---------------------------------------------------------------------
  CityStore _cityStore;
  DistrictStore _districtStore;
  CategoryStore _categoryStore;
  TypeStore _typeStore;
  AmenityStore _amenityStore;
  //focus node:-----------------------------------------------------------------

  //stores:---------------------------------------------------------------------
  final _store = PostFormStore(appComponent.getRepository());

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    try {
      var items = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ))
          ?.files;
      if (items != null) {
        _paths = items;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {}
    if (!mounted) return;
    setState(() {
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  // void _clearCachedFiles() {
  //   FilePicker.platform.clearTemporaryFiles().then((result) {
  //     _scaffoldKey.currentState.showSnackBar(
  //       SnackBar(
  //         backgroundColor: result ? Colors.green : Colors.red,
  //         content: Text((result
  //             ? 'Temporary files removed with success.'
  //             : 'Failed to clean temporary files')),
  //       ),
  //     );
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // get an instance of store class
    _cityStore = Provider.of<CityStore>(context);
    _districtStore = Provider.of<DistrictStore>(context);
    _categoryStore = Provider.of<CategoryStore>(context);
    _typeStore = Provider.of<TypeStore>(context);
    _amenityStore = Provider.of<AmenityStore>(context);
    realodDieldsData().then((value) {
      _store.setFormValues(widget.post);
      isSelected[(_store.countbedroom) - 1] = true;
      _areaController.text = _store.area.toString();
      _descriptionController.text = _store.description;
      _rahnPriceController.text = _store.rahnPrice.toString();
      _rentPriceController.text = _store.rentPrice.toString();
      _buyPriceController.text = _store.buyPrice.toString();
    });

    //start api request if it's not started
  }

  Future<bool> realodDieldsData() async {
    return _categoryStore.getCategories().then((value) {
      if (!_cityStore.loading) {
        _cityStore.getCities().then((value) {
          if (!_typeStore.loading)
            _typeStore.getTypes().then((value) {
              if (!_amenityStore.loading)
                _amenityStore
                    .getAmenities()
                    .then((value) => true)
                    .catchError((_) => false);
            }).catchError((_) => false);
        }).catchError((_) => false);
      }
    }).catchError((_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------
  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).translate('edite_post'),
        style: TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Observer(builder: (context) {
      if (_store.loading == true) {
        return Observer(
          builder: (context) {
            return Visibility(
              visible: _store.loading,
              child: CustomProgressIndicatorWidget(),
            );
          },
        );
      } else {
        if (_cityStore.success == true) {
          return SingleChildScrollView(
            reverse: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: Material(
                child: Stack(
                  children: <Widget>[
                    _handleErrorMessage(),
                    Column(
                      children: <Widget>[
                        _buildRightSide(),
                      ],
                    ),
                    Observer(
                      builder: (context) {
                        return _store.success
                            ? successPost(
                                AppLocalizations.of(context)
                                    .translate('succes_send'),
                              )
                            : _showErrorMessage(_store.errorStore.errorMessage);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: RaisedButton.icon(
                onPressed: () {
                  realodDieldsData();
                },
                icon: Icon(Icons.refresh),
                label: Text("تلاش مجدد")),
          );
        }
      }
    });
  }

  Widget _buildRightSide() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, top: 15, left: 15, right: 15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _buildCategoryField(),
            Row(
              children: [
                _buildCitylistField(),
                VerticalDivider(),
                _buildDistrictlistField(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _buildEditeDistrict(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                _buildHomeTypeField(),
                VerticalDivider(),
                _buildRangeAreaField(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: _popularFilter(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: _buildAgeField(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: _buildBedroomCountField(),
            ),
            _mapFeild(),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: _buildDescriptionField(),
            ),
            _imageFeild(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: _submitbotton(),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getAmeniotiesList(List<Amenity> amenities) {
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
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    onTap: () {
                      setState(() {
                        amenity.isSelected = !amenity.isSelected;
                      });
                      _store.setAmenity(amenity.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            amenity.isSelected
                                ? Icons.check_circle_outline
                                : Icons.radio_button_off_sharp,
                            color: amenity.isSelected
                                ? Colors.green
                                : Colors.grey.withOpacity(0.5),
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

  Widget _submitbotton() {
    return InkWell(
      onTap: () async {
        _store
            .insertPost()
            .then((value) => successPost(
                  AppLocalizations.of(context).translate('succes_send'),
                ))
            .catchError((error) {
          _showErrorMessage(
            "خطا در ایجاد پست",
          );
        });
      },
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffF77E78), Color(0xffF5150A)])),
        child: Text(
          AppLocalizations.of(context).translate('send'),
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _mapFeild() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        icon: _store.latitude == null && _store.longitude == null
            ? const Icon(Icons.add)
            : Icon(
                Icons.done,
                color: Colors.green[400],
              ),
        label: Text("نقشه"),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          pushNewScreen(context,
              withNavBar: false,
              screen: UserMapScreen(
                formState: _store,
              ));
        },
      ),
    );
  }

  Widget _imageFeild() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0xfff3f3f4),
        height: MediaQuery.of(context).size.height * 0.23,
        child: Scrollbar(
          child: _paths != null
              ? GridView.count(
                  crossAxisCount: 4,
                  children: [
                    GridTile(
                      child: InkWell(
                        onTap: () {
                          _openFileExplorer();
                        },
                        child: Card(
                            color: Colors.white,
                            child: Center(
                              child: Icon(Icons.camera_alt_rounded),
                            )),
                      ),
                    ),
                    ...List<Widget>.generate(_paths.length, (index) {
                      return GridTile(
                        child: Card(
                            color: Colors.white,
                            child: Stack(
                              children: [
                                Image.file(
                                  File(_paths[index].path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _paths.removeWhere((item) =>
                                              item.path == _paths[index].path);
                                        });
                                      }),
                                ),
                              ],
                            )),
                      );
                    })
                  ],
                )
              : RaisedButton(
                  color: Color(0xfff3f3f4),
                  child: Image.asset(
                    "assets/images/camera.png",
                    fit: BoxFit.fitHeight,
                    width: 100,
                    height: 100,
                  ),
                  onPressed: () {
                    _openFileExplorer();
                  },
                ),
        ),
      ),
    );
  }

  Widget _popularFilter() {
    return Observer(builder: (context) {
      if (amenityList.length == 0 && _amenityStore.amenityList != null) {
        amenityList = _amenityStore.amenityList.amenities
            .map((item) => SelectedPropertyTypes(
                  id: item.id,
                  titleTxt: item.name,
                  isSelected:
                      _store.amenities.where((m) => m == item.id).isNotEmpty
                          ? true
                          : false,
                ))
            .toList();
      }
      return _amenityStore.amenityList != null &&
              _amenityStore.amenityList.amenities.length > 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('amenities'),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.red[300],
                      fontSize:
                          MediaQuery.of(context).size.width > 360 ? 18 : 16,
                      fontWeight: FontWeight.normal),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: Column(
                    children:
                        getAmeniotiesList(_amenityStore.amenityList.amenities),
                  ),
                ),
              ],
            )
          : Opacity(
              opacity: 1,
              child: Shimmer.fromColors(
                child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 15),
                    child: Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('amenities'),
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    )),
                baseColor: Colors.black12,
                highlightColor: Colors.white,
                loop: 30,
              ),
            );
    });
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate('description'),
          style: TextStyle(color: Colors.red[300]),
        ),
        Observer(builder: (context) {
          return TextField(
            decoration: InputDecoration(
              errorText: _store.formErrorStore.description,
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              // when user presses enter it will adapt to it
            ),
            keyboardType: TextInputType.multiline,
            minLines: 2, //Normal textInputField will be displayed
            maxLines: 5,
            controller: _descriptionController,

            onChanged: (value) {
              _store.setDescription(_descriptionController.text);
            },
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          );
        })
      ],
    );
  }

  upload(int id) async {
    List<MultipartFile> multipart = List<MultipartFile>();
    for (int i = 0; i < _paths.length; i++) {
      multipart.add(await MultipartFile.fromFile(_paths[i].path,
          filename: _paths[i].name));
    }
    _store
        .uploadImages(multipart, id.toString())
        .then((value) => _store.setPostId(null));
  }

  Widget _buildRangeAreaField() {
    return _typeStore.typeList != null
        ? Flexible(
            child: Observer(builder: (context) {
              return TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _areaController,
                onChanged: (value) {
                  var area = int.tryParse(_areaController.text);
                  _store.setArea(area);
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: '',
                  errorText: _store.formErrorStore.area,
                  // hintText: AppLocalizations.of(context).translate('area'),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  labelText: AppLocalizations.of(context).translate('area') +
                      AppLocalizations.of(context).translate('area_range'),
                  contentPadding: EdgeInsets.all(10),
                ),
              );
            }),
          )
        : Flexible(
            child: Opacity(
              opacity: 1,
              child: Shimmer.fromColors(
                child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 15),
                    child: Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('area'),
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    )),
                baseColor: Colors.black12,
                highlightColor: Colors.white,
                loop: 30,
              ),
            ),
          );
  }

  Widget _buildRentPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(AppLocalizations.of(context).translate('rahne'),
                style: TextStyle(color: Colors.red[300])),
            Text(
              AppLocalizations.of(context).translate('currency_type'),
              style: TextStyle(
                  color: Colors.red,
                  fontSize: MediaQuery.of(context).size.width > 360 ? 13 : 13,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _rahnPriceController,
                  onChanged: (value) {
                    _store.setRahnPrice(
                        double.tryParse(_rahnPriceController.text));
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      errorText: _store.formErrorStore.rahnPrice,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                      hintText:
                          AppLocalizations.of(context).translate('rahn_price'),
                      contentPadding: EdgeInsets.all(10))),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEjarePriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(AppLocalizations.of(context).translate('rente'),
                style: TextStyle(color: Colors.red[300])),
            Text(
              AppLocalizations.of(context).translate('currency_type'),
              style: TextStyle(
                  color: Colors.red,
                  fontSize: MediaQuery.of(context).size.width > 360 ? 13 : 13,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                  controller: _rentPriceController,
                  onChanged: (value) {
                    _store.setRentPrice(
                        double.tryParse(_rentPriceController.text));
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      errorText: _store.formErrorStore.rentPrice,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                      hintText:
                          AppLocalizations.of(context).translate('rent_price'),
                      contentPadding: EdgeInsets.all(10))),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBuyPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(
              AppLocalizations.of(context).translate('price'),
              style: TextStyle(color: Colors.red[300]),
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
        Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _buyPriceController,
                  onChanged: (valu) {
                    _store
                        .setBuyPrice(double.tryParse(_buyPriceController.text));
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      errorText: _store.formErrorStore.buyPrice,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                      hintText: AppLocalizations.of(context).translate('price'),
                      contentPadding: EdgeInsets.all(10))),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditeDistrict() {
    return Container(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'شهر',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'منطقه',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'ویرایش',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: const <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Sarah')),
              DataCell(Text('19')),
              DataCell(
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    onPressed: null),
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
        if (_districtStore.districtList != null) {
          return Flexible(
            child: _districtStore.loading == true
                ? LinearProgressIndicator()
                : (_districtStore.districtList.districts.length > 0
                    ? DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          errorText: _store.formErrorStore.district,
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          hintText: AppLocalizations.of(context)
                              .translate('district'),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        onChanged: (int val) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _store.setDistrict(val);
                        },
                        items:
                            _districtStore.districtList.districts.map((item) {
                          return DropdownMenuItem<int>(
                            child: Text(item.name),
                            value: item.id,
                          );
                        }).toList(),
                      )
                    : Text(AppLocalizations.of(context)
                        .translate('notfound_district'))),
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
                        )
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

  Widget _buildAgeField() {
    return Observer(
      builder: (context) {
        return _cityStore.cityList != null
            ? Container(
                padding: EdgeInsets.only(top: 5, bottom: 15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            labelText: AppLocalizations.of(context)
                                .translate('age_home'),
                            fillColor: Color(0xfff3f3f4),
                            filled: true,
                            hintText: AppLocalizations.of(context)
                                .translate('age_home'),
                            contentPadding: EdgeInsets.all(10),
                          ),
                          value: _store.ageHome,
                          onChanged: (int val) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            _store.setAge(val);
                          },
                          items: List.generate(5, (index) {
                            if (index != 4) {
                              return DropdownMenuItem<int>(
                                child: Text((index + 1).toString() + " سال"),
                                value: index,
                              );
                            }
                            return DropdownMenuItem<int>(
                                child: Text("بیش از 5 سال"), value: index);
                          })),
                    ),
                  ],
                ))
            : Opacity(
                opacity: 0.8,
                child: Shimmer.fromColors(
                  child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 15),
                      child: Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).translate('age_home'),
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
      },
    );
  }

  Widget _buildCitylistField() {
    return Observer(
      builder: (context) {
        return _cityStore.cityList != null
            ? Flexible(
                child: DropdownButtonFormField<int>(
                  value: cityDropdownValue,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    labelText: AppLocalizations.of(context).translate('city'),
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                    hintText: AppLocalizations.of(context).translate('city'),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  onChanged: (int val) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    if (val != cityDropdownValue) {
                      setState(() {
                        cityDropdownValue = val;
                      });
                      _districtStore.getDistrictsByCityid(val);
                    }
                  },
                  items: _cityStore.cityList.cities.map((item) {
                    return DropdownMenuItem<int>(
                      child: Text(item.name),
                      value: item.id,
                    );
                  }).toList(),
                ),
              )
            : Flexible(
                child: Opacity(
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
                ),
              );
      },
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
                          if (_value == null) {
                            if (_store.categoryId == null) {
                              _value = category.id;
                              _categoryText = category.name;
                              _store.setCategory(category.id);
                            } else {
                              _value = _store.categoryId;
                              _categoryText = category.name;
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: GestureDetector(
                              onTap: () {
                                if (_value != category.id) {
                                  setState(() {
                                    _categoryText = category.name;
                                    _value = category.id;
                                    resetPrice(category);
                                  });
                                }
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
                    ),
                    if (_categoryText.contains(
                      AppLocalizations.of(context).translate('rahn'),
                    )) ...[
                      Row(
                        children: [
                          Flexible(
                            child: _buildRentPriceField(),
                          ),
                          VerticalDivider(),
                          Flexible(child: _buildEjarePriceField()),
                        ],
                      ),
                    ],
                    if (_value == 1) ...[
                      _buildBuyPriceField(),
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
                              "رهن و گروی",
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
                    loop: 30,
                  ),
                );
        },
      ),
    );
  }

  void resetPrice(Category category) {
    if (category.name.contains("گروی")) {
      _store.resetPrice();

      _buyPriceController.clear();
    } else {
      _store.resetPrice();

      _rahnPriceController.clear();
      _rentPriceController.clear();
    }
  }

  Widget _buildHomeTypeField() {
    return Observer(
      builder: (context) {
        return _typeStore.typeList != null &&
                _typeStore.typeList.types.length > 0
            ? Flexible(
                // width: MediaQuery.of(context).size.width / 2.4,
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                      helperText: '',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                      hintText:
                          AppLocalizations.of(context).translate('type_home'),
                      contentPadding: EdgeInsets.all(10),
                      errorText: _store.formErrorStore.typeHome),
                  onChanged: (int val) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _store.setPropertyHomeType(val);
                  },
                  value: 1,
                  items: _typeStore.typeList.types.map((item) {
                    return DropdownMenuItem<int>(
                      child: Text(item.name),
                      value: item.id,
                    );
                  }).toList(),
                ),
              )
            : Flexible(
                child: Opacity(
                  opacity: 1,
                  child: Shimmer.fromColors(
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 15),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)
                                  .translate('type_home'),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        )),
                    baseColor: Colors.black12,
                    highlightColor: Colors.white,
                    loop: 30,
                  ),
                ),
              );
      },
    );
  }

  Widget _buildBedroomCountField() {
    return Observer(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('count_room'),
            style: TextStyle(color: Colors.red[300]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ToggleButtons(
                children: List.generate(9, (index) {
                  return Text(
                    AppLocalizations.of(context)
                        .transformNumbers((index + 1).toString()),
                  );
                }),
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
                    _store.setcountbedroom(index + 1);
                  });
                },
                isSelected: isSelected,
              ),
            ),
          ),
        ],
      );
    });
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
    Future.delayed(Duration(milliseconds: 0), () async {
      if (message != null && message.isNotEmpty) {
        var flushBar = FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        );
        var _flushbarRoute = route.showFlushbar(
          context: context,
          flushbar: flushBar,
        );

        await Navigator.of(context, rootNavigator: true).push(_flushbarRoute);
      }
    });

    return SizedBox.shrink();
  }

  PostFormStore azar() {
    return _store;
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_amenityStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_amenityStore.errorStore.errorMessage);
        }
        if (_typeStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_typeStore.errorStore.errorMessage);
        }
        if (_categoryStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_categoryStore.errorStore.errorMessage);
        }
        if (_districtStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_districtStore.errorStore.errorMessage);
        }
        if (_cityStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_cityStore.errorStore.errorMessage);
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget successPost(String message) {
    Future.delayed(Duration(milliseconds: 0), () async {
      if (message != null && message.isNotEmpty) {
        var flushBar = FlushbarHelper.createSuccess(
          message: message,
          title: AppLocalizations.of(context).translate('succes_send'),
          duration: Duration(seconds: 3),
        )..show(context);
        var _flushbarRoute = route.showFlushbar(
          context: context,
          flushbar: flushBar,
        );

        await Navigator.of(context, rootNavigator: true).push(_flushbarRoute);
      }
    });
    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _titleController.dispose();
    _descriptionController.dispose();
    _rahnPriceController.dispose();
    _rentPriceController.dispose();
    _buyPriceController.dispose();
    _areaController.dispose();
    _bedroomCountController.dispose();

    super.dispose();
  }
}