import 'dart:io';

import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  final Size size;
  final String path;

  const RoundedImage(
      {Key key, this.size = const Size.fromWidth(120), this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        path,
        width: size.width,
        height: size.width,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
