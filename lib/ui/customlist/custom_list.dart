import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/utils/args/post_args.dart';
import 'list_theme.dart';

class HotelListView extends StatefulWidget {
  const HotelListView(
      {Key key,
      this.post,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Post post;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  _HotelListViewState createState() => _HotelListViewState();
}

class _HotelListViewState extends State<HotelListView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  widget.callback();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: GestureDetector(
                      onTap: () {
                        Future.delayed(Duration(milliseconds: 2), () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.post, (Route<dynamic> route) => false,
                              arguments: PostArguments(widget.post.id));
                        });
                      },
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 2,
                                child: widget.post.images != null &&
                                        widget.post.images.length > 0
                                    ? Image.network(
                                        Endpoints.baseUrl +
                                            '/' +
                                            widget.post.images[0].path,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/a.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Container(
                                color: HotelAppTheme.buildLightTheme()
                                    .backgroundColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8,
                                              left: 8,
                                              top: 8,
                                              bottom: 8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    widget.post.title,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                  Text(
                                                    '\$${widget.post.price}',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      widget.post.category.name,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.8)),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Icon(
                                                      FontAwesomeIcons
                                                          .mapMarkerAlt,
                                                      size: 12,
                                                      color: HotelAppTheme
                                                              .buildLightTheme()
                                                          .primaryColor,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${widget.post.district.name} - ${widget.post.district.city.name}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.8)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .bed,
                                                              color: Colors
                                                                  .blue[400],
                                                              size: 20,
                                                            ),
                                                            onPressed: null),
                                                        Text(
                                                          '${widget.post.bedroom}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      1)),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .history,
                                                              color: Colors
                                                                  .blue[400],
                                                              size: 20,
                                                            ),
                                                            onPressed: null),
                                                        Text(
                                                          '${widget.post.age}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      1)),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .home,
                                                              color: Colors
                                                                  .blue[400],
                                                              size: 20,
                                                            ),
                                                            onPressed: null),
                                                        Text(
                                                          '${widget.post.area}(متر مربع)',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      1)),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .shareAlt,
                                                              size: 20,
                                                              color: Colors
                                                                  .blue[400],
                                                            ),
                                                            onPressed: () {}),
                                                        Text(
                                                          "اشتراک گذاری",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      1)),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(32.0),
                                ),
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: HotelAppTheme.buildLightTheme()
                                        .primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
