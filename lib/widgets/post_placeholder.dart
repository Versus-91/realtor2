import 'package:boilerplate/models/post/post.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaceholderItemCard extends StatelessWidget {
  const PlaceholderItemCard({Key key, @required this.item}) : super(key: key);

  final Post item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                    child: Container(
                      color: Colors.white,
                      child: Text(
                        ' item.name',
                        style: TextStyle(color: Colors.transparent),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Container(
                  color: Colors.white,
                  child: Text(
                    'item.message',
                    style: TextStyle(color: Colors.transparent),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
