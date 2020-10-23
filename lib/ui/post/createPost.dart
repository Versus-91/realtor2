import 'dart:io';

import 'package:boilerplate/main.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/category/category_store.dart';
import 'package:boilerplate/stores/city/city_store.dart';
import 'package:boilerplate/stores/district/district_store.dart';
import 'package:boilerplate/stores/form/post_form.dart';
import 'package:boilerplate/stores/type/type_store.dart';
import 'package:boilerplate/ui/post/user_map_screen.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'dart:async';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key key}) : super(key: key);
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

// enum SelectTypeHome { Maskoni, Tejari, Sanati }

class _CreatePostScreenState extends State<CreatePostScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedItem;
  int _value;
  String _categoryText = '';
  String _fileName;
  List<PlatformFile> _paths;
  String _extension;
  bool _multiPick = true;
  FileType _pickingType = FileType.image;
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
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get an instance of store class
    _cityStore = Provider.of<CityStore>(context);
    _districtStore = Provider.of<DistrictStore>(context);
    _categoryStore = Provider.of<CategoryStore>(context);
    _typeStore = Provider.of<TypeStore>(context);

    //start api request if it's not started
    if (!_cityStore.loading) _cityStore.getCities();
    if (!_districtStore.loading) _districtStore.getDistricts();
    if (!_categoryStore.loading) _categoryStore.getCategories();
    if (!_typeStore.loading) _typeStore.getTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: _buildAppBar(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(15),
        child: InkWell(
          onTap: () async {
            _store.insertPost();
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 15),
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
              'ارسال',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------
  Widget _buildAppBar() {
    return AppBar(
      title: Text("ارسال آگهی"),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Observer(builder: (context) {
      return _store.loading == true
          ? Observer(
              builder: (context) {
                return Visibility(
                  visible: _store.loading,
                  child: CustomProgressIndicatorWidget(),
                );
              },
            )
          : SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottom),
                child: Material(
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          _buildRightSide(),
                        ],
                      ),
                      Observer(
                        builder: (context) {
                          return _store.success
                              ? successPost('با موفقیت ارسال شد')
                              : _showErrorMessage(
                                  _store.errorStore.errorMessage);
                        },
                      ),
                      Observer(
                        builder: (context) {
                          if (_store.postId != null) {
                            upload(_store.postId);
                            return Text('data');
                          }
                          return _showErrorMessage(
                              _store.errorStore.errorMessage);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }

  Widget _buildRightSide() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, top: 15, left: 15, right: 15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // _buildTitleField(),
            _buildCategoryField(),
            const Divider(
              height: 1,
            ),
            Row(
              children: [
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: _buildCitylistField(),
                )),
                Flexible(child: _buildDistrictlistField()),
              ],
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Flexible(
                      child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: _buildHomeTypeField(),
                  )),
                  Flexible(child: _buildRangeAreaField()),
                ],
              ),
            ),

            const Divider(
              height: 1,
            ),
            if (_categoryText.contains('رهن')) ...[
              Row(
                children: [
                  Flexible(
                    child: _buildRentPriceField(),
                  ),
                  Flexible(child: _buildEjarePriceField()),
                ],
              ),
            ],

            if (_value == 1) ...[
              _buildBuyPriceField(),
            ],
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: _buildBedroomCountField(),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: _buildDescriptionField(),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                color: Colors.white12,
                height: 120, // constrain height
                child: _paths != null
                    ? Container(
                        color: Colors.blueGrey[50],
                        padding: const EdgeInsets.only(bottom: 30.0),
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: Scrollbar(
                            child: ListView.separated(
                          itemCount: _paths != null && _paths.isNotEmpty
                              ? _paths.length
                              : 1,
                          itemBuilder: (BuildContext context, int index) {
                            final bool isMultiPath =
                                _paths != null && _paths.isNotEmpty;
                            final String name = 'File $index: ' +
                                (isMultiPath
                                    ? _paths.map((e) => e.name).toList()[index]
                                    : _fileName ?? '...');
                            final path = _paths
                                .map((e) => e.path)
                                .toList()[index]
                                .toString();

                            return ListTile(
                              leading: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 44,
                                  minHeight: 44,
                                  maxWidth: 64,
                                  maxHeight: 64,
                                ),
                                child: Image.file(
                                  File(path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              title: Text(
                                name,
                              ),
                              // subtitle: Text(path),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        )),
                      )
                    : const SizedBox(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 15, top: 15),
              child: RaisedButton(
                color: Colors.green[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "آپلود عکس",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.cloud_upload,
                      color: Colors.white,
                    ),
                  ],
                ),
                onPressed: () => _openFileExplorer(),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                FloatingActionButton.extended(
                  icon: const Icon(Icons.add_location_alt),
                  label: Text("افزودن نقشه"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserMapScreen(
                                formState: _store,
                                // latitude: store.latitude,
                                // longitude: store.longitude,
                              )),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTitleField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "عنوان آگهی",
  //         style: TextStyle(color: Colors.red[300]),
  //       ),
  //       TextField(
  //         decoration: InputDecoration(
  //            hintText: 'عنوان',
  //           // when user presses enter it will adapt to it
  //         ),
  //         keyboardType: TextInputType.multiline,
  //         minLines: 1, //Normal textInputField will be displayed
  //         controller: _titleController,
  //         onChanged: (value) {
  //           _store.setTitle(_titleController.text);
  //         },
  //         textAlign: TextAlign.right,
  //         textDirection: TextDirection.rtl,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "توضیحات",
          style: TextStyle(color: Colors.red[300]),
        ),
        TextField(
          decoration: InputDecoration(
            errorText: _store.formErrorStore.description,

            border: InputBorder.none,
            fillColor: Color(0xfff3f3f4),
            filled: true,
            // when user presses enter it will adapt to it
          ),
          keyboardType: TextInputType.multiline,
          minLines: 3, //Normal textInputField will be displayed
          maxLines: 5,
          controller: _descriptionController,

          onChanged: (value) {
            _store.setDescription(_descriptionController.text);
          },
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        )
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
    return Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            controller: _areaController,
            onChanged: (value) {
              var area = int.tryParse(_areaController.text) ?? 0;
              _store.setArea(area);
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              errorText: _store.formErrorStore.area,
              hintText: 'متراژ',
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              contentPadding: EdgeInsets.all(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRentPriceField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(" رهن کامل", style: TextStyle(color: Colors.red[300])),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    // textInputAction: TextInputAction.next,
                    controller: _rahnPriceController,
                    onChanged: (value) {
                      var price =
                          double.tryParse(_rahnPriceController.text) ?? 0;
                      _store.setRahnPrice(price);
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        errorText: _store.formErrorStore.rahnPrice,
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        hintText: "قیمت رهن",
                        contentPadding: EdgeInsets.all(10))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEjarePriceField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(" اجاره کامل", style: TextStyle(color: Colors.red[300])),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    controller: _rentPriceController,
                    onChanged: (value) {
                      var price =
                          double.tryParse(_rentPriceController.text) ?? 0;
                      _store.setRentPrice(price);
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        errorText: _store.formErrorStore.rentPrice,
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        hintText: "قیمت اجاره",
                        contentPadding: EdgeInsets.all(10))),
              ),
            ],
          ),
        ],
      ),
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
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    controller: _buyPriceController,
                    onChanged: (valu) {
                      var price =
                          double.tryParse(_buyPriceController.text) ?? 0;
                      _store.setBuyPrice(price);
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        errorText: _store.formErrorStore.buyPrice,
                        hintText: "قیمت",
                        border: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
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
                padding: EdgeInsets.only(top: 10, bottom: 15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          hintText: "محله",
                          contentPadding: EdgeInsets.all(10),
                        ),
                        onChanged: (int val) => setState(() => {
                              selectedItem = val,
                              _store.setDistrict(val),
                            }),
                        items:
                            _districtStore.districtList.districts.map((item) {
                          return DropdownMenuItem<int>(
                            child: Text(item.name),
                            value: item.id,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ))
            : Container(
                child: FlatButton(
                    onPressed: () {
                      _districtStore.getDistricts();
                    },
                    child: Icon(Icons.refresh)),
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
                padding: EdgeInsets.only(top: 10, bottom: 15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          hintText: "شهر",
                          contentPadding: EdgeInsets.all(10),
                        ),
                        onChanged: (int val) => setState(() => {
                              selectedItem = val,
                              _store.setCity(val),
                            }),
                        items: _cityStore.cityList.cities.map((item) {
                          return DropdownMenuItem<int>(
                            child: Text(item.name),
                            value: item.id,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ))
            : Container(
                child: FlatButton(
                    onPressed: () {
                      _cityStore.getCities();
                    },
                    child: Icon(Icons.refresh)),
              );
      },
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
                            _categoryText = category.name;
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

  Widget _buildHomeTypeField() {
    return Observer(
      builder: (context) {
        return _typeStore.typeList != null
            ? DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  hintText: "نوع ملک",
                  contentPadding: EdgeInsets.all(10),
                ),
                onChanged: (int val) => setState(() => {
                      selectedItem = val,
                      _store.setPropertyHomeType(val),
                    }),
                items: _typeStore.typeList.types.map((item) {
                  return DropdownMenuItem<int>(
                    child: Text(item.name),
                    value: item.id,
                  );
                }).toList(),
              )
            : Container(
                child: FlatButton(
                    onPressed: () {
                      _typeStore.getTypes();
                    },
                    child: Icon(Icons.refresh)),
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
                  _store.setcountbedroom(index + 1);
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

  dynamic successPost(String message) async {
    return Future.delayed(Duration(milliseconds: 0), () {
      if (message != null && message.isNotEmpty) {
        FlushbarHelper.createSuccess(
          message: message,
          title: 'با موفقیت ارسال شد',
          duration: Duration(seconds: 3),
        )..show(context);
      }
    }).then((value) => {navigate(context)});
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
