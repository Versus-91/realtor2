import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/main.dart';
import 'package:boilerplate/models/amenity/amenity.dart';
import 'package:boilerplate/models/optionreport/optionReport.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/report/report.dart';
import 'package:boilerplate/ui/map/map.dart';
import 'package:boilerplate/ui/search/model/pop_list.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class PostScreen extends StatefulWidget {
  PostScreen({this.post});
  final Post post;
  final Repository repository = appComponent.getRepository();
  @override
  _PostScreen createState() => _PostScreen();
}

class _PostScreen extends State<PostScreen> {
  List<OptionReport> options;
  AnimationController animationController;
  TextEditingController _descriptionController = TextEditingController();
  int _chosenValue;

  Future getOptions;
  bool isSendigReport = false;
  bool liked = false;
  int favoriteId;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getOptions = widget.repository.getOptionsReport();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[700],
          title: Text(
            ' ${widget.post.district.area.city.name} - ${widget.post.district.name} ',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
          actions: [],
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  _showDecline();
                },
                icon: Icon(
                  Icons.flag,
                  color: Colors.red,
                ),
                label: Text(
                  AppLocalizations.of(context).translate('report'),
                ),
              ),
              FlatButton.icon(
                onPressed: () async {
                  await Share.share(
                      Endpoints.baseUrl + '/ads/' + widget.post.id.toString());
                },
                label: Text(
                  AppLocalizations.of(context).translate('send'),
                ),
                icon: Icon(
                  Icons.share,
                  color: Colors.blue,
                ),
              ),
              FlatButton.icon(
                onPressed: () async {
                  await widget.repository
                      .getNumber(widget.post.creatorUserId.toString())
                      .then((res) {
                    return launch("tel://" + res.toString());
                  });
                },
                label: Text(
                  AppLocalizations.of(context).translate('call'),
                ),
                icon: Icon(
                  Icons.call,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox(
                    height: 250.0,
                    child: Stack(
                      children: <Widget>[
                        if (widget.post.images.length > 0) ...[
                          Carousel(
                            images: List<Image>.generate(
                                widget.post.images.length, (index) {
                              return Image.network(
                                Endpoints.baseUrl +
                                    "/" +
                                    widget.post.images[index].path,
                                fit: BoxFit.cover,
                              );
                            }),
                            dotSize: 4.0,
                            dotSpacing: 15.0,
                            autoplay: false,
                            dotColor: Colors.white,
                            indicatorBgPadding: 10.0,
                            dotBgColor: Colors.transparent,
                            borderRadius: false,
                            moveIndicatorFromBottom: 200.0,
                            noRadiusForIndicator: true,
                          )
                        ] else ...[
                          Center(
                              child: Image.asset("assets/images/a.png",
                                  fit: BoxFit.fill))
                        ],
                      ],
                    )),
              ],
            ),
            Container(
                color: Colors.blueGrey[700],
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: Center(
                  child: Text(
                    '${widget.post.category.name}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )),
            //  padding: EdgeInsets.only(top: 20, right: 14, left: 0),
            Container(
              alignment: Alignment.topLeft,
              child: FlatButton(
                splashColor: Colors.white,
                child: FutureBuilder(
                  future: isSelected(widget.post.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Icon(
                        Icons.favorite,
                        color: Colors.black,
                      );
                    } else {
                      if (snapshot.data != 0) {
                        return Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        );
                      }
                      return Icon(
                        Icons.favorite,
                        color: Colors.grey,
                      );
                    }
                  },
                ),
                onPressed: () async {
                  if (favoriteId == 0) {
                    widget.repository
                        .addFavoriteInServer(widget.post.id)
                        .then((value) async {
                      setState(() {
                        isSelected(widget.post.id);
                      });
                    });
                  } else {
                    widget.repository
                        .removeFavoriteInServer(favoriteId)
                        .then((value) async {
                      setState(() {
                        isSelected(widget.post.id);
                      });
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('for') +
                            " ${widget.post.category.name}",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Divider(
                        endIndent: MediaQuery.of(context).size.width / 1.5,
                        color: Colors.blueGrey,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .transformCurrency(widget.post.price),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                  IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(AppLocalizations.of(context)
                                  .translate('post_id')),
                              Text(AppLocalizations.of(context)
                                  .transformNumbers(widget.post.id.toString()))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: VerticalDivider(
                              color: Colors.blueGrey,
                              width: 10,
                              endIndent: 4,
                            ),
                          ),
                          Column(
                            children: [
                              Text(AppLocalizations.of(context)
                                  .translate('count_room')),
                              Text(AppLocalizations.of(context)
                                  .transformNumbers(
                                      widget.post.bedroom.toString()))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: VerticalDivider(
                              color: Colors.blueGrey,
                              width: 10,
                              endIndent: 4,
                            ),
                          ),
                          Column(
                            children: [
                              Text(AppLocalizations.of(context)
                                  .translate('area')),
                              Text(AppLocalizations.of(context)
                                  .transformNumbers(
                                      widget.post.area.toString()))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: VerticalDivider(
                              color: Colors.blueGrey,
                              width: 10,
                              endIndent: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('description'),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ConcertOne-Regular'),
                  ),
                  Divider(
                    endIndent: MediaQuery.of(context).size.width / 1.5,
                    color: Colors.blueGrey,
                    thickness: 1,
                  ),
                  descriptionFeild('${widget.post.description}'),
                  if (widget.post.latitude == null) ...[
                    SizedBox.shrink()
                  ] else ...[
                    widget.post.amenities != null &&
                            widget.post.amenities.length > 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('amenities'),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ConcertOne-Regular'),
                              ),
                              Divider(
                                endIndent:
                                    MediaQuery.of(context).size.width / 1.5,
                                color: Colors.blueGrey,
                                thickness: 1,
                              ),
                              Column(
                                children:
                                    getAmeniotiesList(widget.post.amenities),
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 5, left: 5, right: 5),
              child: Center(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                height: 260,
                child: MapScreen(
                  latitude: widget.post.latitude,
                  longitude: widget.post.longitude,
                ),
              )),
            ),
          ],
        ));
  }

  List<Widget> getAmeniotiesList(List<Amenity> amenities) {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < amenities.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          var item = amenities[count];
          final SelectedPropertyTypes amenity = SelectedPropertyTypes(
              icon: item.icon, titleTxt: item.name, isSelected: true);
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
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

  Future isSelected(int id) async {
    var post = await widget.repository.getFavoriteInStatus(id);
    print('trigger');
    if (post["isLiked"] == true) {
      favoriteId = post["id"];
      return post["id"];
    }
    favoriteId = 0;
    return 0;
  }

  void _showDecline() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Center(child: Text("گزارش خطا")),
              content: isSendigReport == true
                  ? CircularProgressIndicator()
                  : SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Text("لطفا گزینه مورد نظر خود را وارد کنید."),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                              future: getOptions,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<DropdownMenuItem<int>> menuItems =
                                      snapshot.data.options
                                          .map<DropdownMenuItem<int>>((item) {
                                    return DropdownMenuItem<int>(
                                      child: Text(item.name),
                                      value: item.id,
                                    );
                                  }).toList();

                                  return DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      // labelText: AppLocalizations.of(context)
                                      //     .translate('city'),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                      // hintText: AppLocalizations.of(context)
                                      //     .translate('city'),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                    hint: Text(
                                      'یک گزینه را انتخاب کنید',
                                      style: TextStyle(color: Colors.blueGrey),
                                    ),
                                    value: _chosenValue,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'این فیلد باید انتخاب شود';
                                      }
                                      return null;
                                    },
                                    autovalidateMode: AutovalidateMode.always,
                                    items: menuItems,
                                    onChanged: (int value) {
                                      setState(() {
                                        _chosenValue = value;
                                      });
                                    },
                                  );
                                } else {
                                  return Center(child: Text("Loading..."));
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildDescriptionField()
                          ],
                        ),
                      ),
                    ),
              actionsPadding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width / 5),
              actions: isSendigReport == false
                  ? <Widget>[
                      registerButton(),
                      cancelButton(),
                    ]
                  : <Widget>[
                      SizedBox.shrink(),
                    ],
            );
          },
        );
      },
    );
  }

  void resetReport() {
    _descriptionController.clear();
    _chosenValue = null;
  }

  Widget cancelButton() {
    return FlatButton(
        color: Colors.red,
        textColor: Colors.white,
        child: Text(AppLocalizations.of(context).translate('cancel')),
        onPressed: () async {
          resetReport();
          Navigator.pop(context);
        });
  }

  Widget registerButton() {
    return FlatButton(
        color: Colors.green,
        textColor: Colors.white,
        child: Text(AppLocalizations.of(context).translate('register_info')),
        onPressed: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          if (_formKey.currentState.validate()) {
            setState(() {
              isSendigReport = true;
            });
            appComponent
                .getRepository()
                .insertReport(Report(
                    postId: widget.post.id,
                    reportOptionId: _chosenValue,
                    description: _descriptionController.text))
                .then((value) async {
              resetReport();

              Navigator.of(context).pop();
              successMessage('گزارش با موفقیت ارسال شد');
              setState(() {
                isSendigReport = false;
              });
            }).catchError((error) {
              setState(() {
                isSendigReport = false;
              });
              return _showErrorMessage(
                "خطا در ارسال",
              );
            });
          }
        });
  }

  Widget successMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () async {
      if (message != null && message.isNotEmpty) {
        FlushbarHelper.createSuccess(
          message: message,
          title: AppLocalizations.of(context).translate('succes_send'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });
    return SizedBox.shrink();
  }

  Widget _showErrorMessage(String message) {
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

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate('description'),
          style: TextStyle(color: Colors.black),
        ),
        TextField(
          decoration: InputDecoration(
            // errorText: validateDescription(_descriptionController.text),
            border: InputBorder.none,
            fillColor: Color(0xfff3f3f4),
            filled: true,
            // when user presses enter it will adapt to it
          ),
          keyboardType: TextInputType.multiline,
          minLines: 2, //Normal textInputField will be displayed
          maxLines: 5,
          controller: _descriptionController,

          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        )
      ],
    );
  }

  Widget amenities(
    String url1,
    String url2,
    String url3,
    String features1,
    String features2,
    String features3,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 1.0),
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 0.2)
                ]),
            child: Column(
              children: <Widget>[
                Image.asset(
                  url1,
                  fit: BoxFit.contain,
                  height: 40.0,
                  width: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(features1)
              ],
            )),
        Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 1.0),
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 0.2)
                ]),
            child: Column(
              children: <Widget>[
                Image.asset(
                  url2,
                  fit: BoxFit.contain,
                  height: 40.0,
                  width: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(features2)
              ],
            )),
        Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 1.0),
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 0.2)
                ]),
            child: Column(
              children: <Widget>[
                Image.asset(
                  url3,
                  fit: BoxFit.contain,
                  height: 40.0,
                  width: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(features3)
              ],
            )),
      ],
    );
  }

  Widget descriptionFeild(
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          description,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _descriptionController.clear();
    super.dispose();
  }
}
