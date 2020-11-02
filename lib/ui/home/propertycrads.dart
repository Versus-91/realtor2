import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/ui/post/postscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PropertyCrads extends StatefulWidget {
  PropertyCrads({this.store});
  final PostStore store;
  @override
  _PropertyCradsState createState() => _PropertyCradsState();
}

class _PropertyCradsState extends State<PropertyCrads> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Observer(builder: (context) {
      return widget.store.postList != null
          ? Column(
              children: List<Widget>.generate(
                  widget.store.postList.posts.length, (index) {
              var url = 'assets/images/placeholder.png';
              if (widget.store.postList.posts[index].images.length > 0) {
                url = Endpoints.baseUrl +
                    "/" +
                    widget.store.postList.posts[index].images[0]?.path;
              }

              return houseWidget(
                widget.store.postList.posts[index],
                url,
                widget.store.postList.posts[index].category.name,
                '${widget.store.postList.posts[index].district.city.name}, ${widget.store.postList.posts[index].district.name}',
                '${widget.store.postList.posts[index].bedroom}',
                'assets/images/bed.png',
                '${widget.store.postList.posts[index].age}',
                'assets/icons/time.png',
              );
            }))
          : Container(
              padding: new EdgeInsets.only(top: 26.0),
              child: Text('موردی یافت نشد'));
    }));
  }

  Widget houseWidget(
    Post post,
    String imageurl,
    String type,
    String place,
    String no1,
    String no1Url,
    String no2,
    String no2Url,
  ) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostScreen(
                      post: post,
                    )),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 5),
          child: Container(
            height: 310,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              elevation: 4.0,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 500,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                          child: imageurl.contains(Endpoints.baseUrl)
                              ? Image.network(
                                  imageurl,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  imageurl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 6.0,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0)),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        left: 6.0,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0)),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              place,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff1089ff),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 12),
                    child: !type.contains('رهن')
                        ? Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(
                              post.price.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(
                              'رهن: ${post.deopsit} , اجاره: ${post.rent}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                  ),
                  SizedBox(height: 7.0),
                  Container(
                      width: MediaQuery.of(context).size.width - 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                no1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(width: 10),
                              Image.asset(
                                no1Url,
                                fit: BoxFit.contain,
                                height: 30.0,
                                width: 30.0,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                no1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(width: 10),
                              Image.asset(
                                no1Url,
                                fit: BoxFit.contain,
                                height: 30.0,
                                width: 30.0,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                no2 == '0' ? 'N/A' : no2,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(width: 10),
                              Image.asset(
                                no2Url,
                                fit: BoxFit.contain,
                                height: 30.0,
                                width: 30.0,
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
