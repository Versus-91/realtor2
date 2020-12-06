import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/main.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/ui/map/map.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class PostScreen extends StatefulWidget {
  PostScreen({this.post});
  final Post post;
  @override
  _PostScreen createState() => _PostScreen();
}

class _PostScreen extends State<PostScreen> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  int currentState = 0;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = Tween(begin: 0, end: 60).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {},
                icon: Icon(Icons.save),
                label: Text(
                  AppLocalizations.of(context).translate('save'),
                ),
              ),
              FlatButton.icon(
                onPressed: () async {
                  await Share.share('sdasdas');
                },
                label: Text(
                  AppLocalizations.of(context).translate('send'),
                ),
                icon: Icon(Icons.share),
              ),
              FlatButton.icon(
                onPressed: () => launch("tel://21213123123"),
                label: Text(
                  AppLocalizations.of(context).translate('call'),
                ),
                icon: Icon(Icons.call),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            ' ${widget.post.district.city.name} - ${widget.post.district.name} ',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
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
                            })
                            // Photo from https://unsplash.com/photos/BVd8jS5H7VU
                            ,
                            dotSize: 4.0,
                            dotSpacing: 15.0,
                            autoplay: false,
                            dotColor: Colors.white,
                            indicatorBgPadding: 50.0,
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
                        color: Colors.white,
                      );
                    } else {
                      if (snapshot.data == true) {
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
                  var post = await appComponent
                      .getRepository()
                      .findFavoriteById(widget.post.id);
                  if (currentState == 0) {
                    animationController.forward();
                    currentState = 1;
                  } else {
                    animationController.reverse();
                    currentState = 0;
                  }
                  if (post == null) {
                    await appComponent.getRepository().addFavorite(widget.post);
                  } else {
                    await appComponent
                        .getRepository()
                        .removeFavorite(widget.post);
                  }
                  setState(() {
                    isSelected(widget.post.id);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('for') +
                        " ${widget.post.category.name}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  widget.post.category.name.contains(
                          AppLocalizations.of(context).translate('sell'))
                      ? Text(
                          AppLocalizations.of(context)
                              .transformCurrency(widget.post.price),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              AppLocalizations.of(context).translate('rahn') +
                                  '${widget.post.deopsit}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              AppLocalizations.of(context).translate('rent') +
                                  '${widget.post.rent}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Divider(
                endIndent: MediaQuery.of(context).size.width / 1.5,
                color: Colors.black54,
              ),
            ),
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 14,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(AppLocalizations.of(context).translate('post_id')),
                        Text(AppLocalizations.of(context)
                            .transformNumbers(widget.post.id.toString()))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: VerticalDivider(
                        color: Colors.grey,
                        width: 10,
                        endIndent: 4,
                      ),
                    ),
                    Column(
                      children: [
                        Text(AppLocalizations.of(context).translate('bed')),
                        Text(AppLocalizations.of(context)
                            .transformNumbers(widget.post.bedroom.toString()))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: VerticalDivider(
                        color: Colors.grey,
                        width: 10,
                        endIndent: 4,
                      ),
                    ),
                    Column(
                      children: [
                        Text(AppLocalizations.of(context).translate('area')),
                        Text(AppLocalizations.of(context)
                            .transformNumbers(widget.post.area.toString()))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: VerticalDivider(
                        color: Colors.grey,
                        width: 10,
                        endIndent: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 14, left: 14),
              child: Text(
                AppLocalizations.of(context).translate('description'),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ConcertOne-Regular'),
              ),
            ),
            aboutHotel('${widget.post.description}'),
            if (widget.post.latitude == null) ...[
              SizedBox.shrink()
            ] else ...[
              Padding(
                padding:
                    EdgeInsets.only(top: 50, bottom: 50, left: 0, right: 0),
                child: Center(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: MapScreen(
                    latitude: widget.post.latitude,
                    longitude: widget.post.longitude,
                  ),
                )),
              ),
              // DataTable(
              //   columns: const <DataColumn>[
              //     DataColumn(
              //       label: Text(
              //         'امکانات',
              //         style: TextStyle(fontStyle: FontStyle.normal),
              //       ),
              //     ),
              //     DataColumn(
              //       label: Text('وضعیت'),
              //     ),
              //   ],
              //   // rows: <DataRow>[
              //   //   DataRow(
              //   //       cells:
              //   //           List.generate(widget.post.amenities.length, (index) {
              //   //     return DataCell(Text('19'));
              //   //   })),
              //   // ],
              // ),
            ],
          ],
        ));
  }

  Future isSelected(int id) async {
    var post = await appComponent.getRepository().findFavoriteById(id);
    if (post != null) {
      return true;
    }
    return false;
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

  Widget aboutHotel(
    String description,
  ) {
    return Padding(
        padding: EdgeInsets.only(left: 14, right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              description,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ],
        ));
  }
}
