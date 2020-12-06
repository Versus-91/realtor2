import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaceholderPostCard extends StatelessWidget {
  const PlaceholderPostCard({Key key}) : super(key: key);

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
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     Container(
              //       width: 60.0,
              //       height: 60.0,
              //       color: Colors.white,
              //     ),
              //     // Padding(
              //     //   padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
              //     //   child: Container(
              //     //     color: Colors.white,
              //     //     child: Text(
              //     //       'item.title',
              //     //       style: TextStyle(color: Colors.transparent),
              //     //     ),
              //     //   ),
              //     // )
              //   ],
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Container(
                  color: Colors.white,
                  child: Text(
                    'Lorem ipsum dolor sit amet, consco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
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
