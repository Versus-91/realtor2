import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/ui/post/postscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:getwidget/direction/gf_shimmer_direction.dart';
import '../../stores/post/post_store.dart';

class UserHomeList extends StatefulWidget {
  UserHomeList({Key key, this.store});
  final PostStore store;
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<UserHomeList> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (widget.store.userPostList != null) {
        if (widget.store.userPostList.posts.length > 0) {
          return Container(
            height: 300,
            width: 220,
            child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(10.0),
                children: List<Widget>.generate(
                    widget.store.userPostList.posts.length, (index) {
                  var post = widget.store.userPostList.posts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostScreen(
                                post: widget.store.userPostList.posts[index])),
                      );
                    },
                    child: postCard(
                      'assets/images/house2.jpg',
                      "${post.categoryId}-${post.district.name} - ${post.district.city.name}-${post.typeId}",
                      post.isVerified,
                    ),
                  );
                })),
          );
        } else {
          return Container(
            height: 300,
            width: 220,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                    color: Colors.greenAccent,
                    hoverColor: Colors.white,
                    child: Text('ارسال آگهی جدید'),
                    onPressed: () => print('object'))
              ],
            ),
          );
        }
      } else {
        return Container(
          height: 300,
          width: 220,
          child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(10.0),
              children: List<Widget>.generate(4, (index) {
             
                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GFShimmer(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.topLeft,
                      stops: const <double>[0, 0.3, 0.6],
                      colors: [
                        Colors.red[300],
                        Colors.red[200],
                        Colors.red[100],
                      ],
                    ),
                    showGradient: true,
                    direction: GFShimmerDirection.topToBottom,
                    duration: const Duration(milliseconds: 1500),
                    child: shimmer(context),
                  ),
                );
              })),
        );
      }
    });
  }

  Widget shimmer(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              color: Colors.white,
            ),
            const SizedBox(
              width: 30,
              height: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 8,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 8,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 8,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 8,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      );
  Widget postCard(
    String imageurl,
    String name,
    bool verified,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: <Widget>[
              Image.asset(
                imageurl,
                height: 230,
                width: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 16,
                left: 100,
                child: Container(
                    height: 25.0,
                    width: 80.00,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: Color(0xff0F0F0F),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff0F0F0F).withOpacity(0.3),
                          )
                        ]),
                    child: Center(
                      child: verified == false
                          ? Text(
                              'در حال بررسی',
                              style: TextStyle(color: Colors.white),
                            )
                          : SizedBox.shrink(),
                    )),
              )
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8,
          margin: EdgeInsets.all(10),
        ),
        Padding(
          padding: EdgeInsets.only(right: 14),
          child: Text(
            name,
            style: TextStyle(fontFamily: 'ConcertOne-Regular'),
          ),
        ),
      ],
    );
  }

  stars(int rating, int index) {
    if (index <= rating) {
      return Icon(
        Icons.star,
        color: Colors.amber,
        size: 13.0,
      );
    } else {
      return Icon(Icons.star, color: Colors.grey, size: 13.0);
    }
  }
}
