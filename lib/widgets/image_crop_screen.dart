import 'dart:io';

import 'package:boilerplate/plugin/cropper.dart';
import 'package:flutter/material.dart';

class ImageCropScreen extends StatefulWidget {
  @override
  _ImageCropScreenState createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final cropKey = GlobalKey<ImgCropState>();

  void showImage(BuildContext context, File file) async {
    new FileImage(file)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      print('------$info');
    }));
    Navigator.pop(context, file);
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'برش/زوم',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.navigate_before, color: Colors.black, size: 40),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: ImgCrop(
            key: cropKey,
            chipRadius: 100,
            chipShape: ChipShape.circle,
            chipRatio: 2 / 1,
            maximumScale: 1,
            image: FileImage(args['image']),
            // handleSize: 0.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          onPressed: () async {
            final crop = cropKey.currentState;
            final croppedFile =
                await crop.cropCompleted(args['image'], preferredSize: 1000);

            showImage(context, croppedFile);
          },
          tooltip: 'تایید',
          child: Text('ارسال'),
        ));
  }
}
