import 'package:boilerplate/stores/post/post_store.dart';
import 'package:flutter/material.dart';

class RecommendedPlace extends StatefulWidget {
  RecommendedPlace({this.store});
  final PostStore store;
  @override
  _RecommendedPlaceState createState() => _RecommendedPlaceState();
}

class _RecommendedPlaceState extends State<RecommendedPlace> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          Explore(
            'assets/images/img_login.jpg',
            'Golden Bridge',
          ),
          // Photo from https://unsplash.com/photos/gZXx8lKAb7Y
          Explore(
            'assets/images/house1.jpg',
            'Eiffel Tower',
          ),
          // Photo from https://unsplash.com/photos/ZHP6JNIXtfQ
          Explore(
            'assets/images/img_home.jpg',
            'Grand Canyon',
          ),
          // Photo from https://unsplash.com/photos/EkI9kedvfjA
          Explore(
            'assets/images/img_splash.png',
            'Krabi',
          ),
          // Photo from https://unsplash.com/photos/dd_hrEMsF2o
        ],
      ),
    );
  }

  Widget Explore(
    String imageurl,
    String city,
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
                height: 220,
                width: 180,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 170,
                left: 40,
                child: Container(
                    height: 30.0,
                    width: 100.00,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: Color(0xff0F0F0F),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff0F0F0F).withOpacity(0.3),
                          )
                        ]),
                    child: Center(
                      child: Text(
                        city,
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              )
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
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
