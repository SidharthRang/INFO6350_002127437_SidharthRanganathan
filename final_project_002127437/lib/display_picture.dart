import 'dart:io';

import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String imageTitle;
  final String screen;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
    required this.imageTitle,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(imageTitle)),
      backgroundColor: Colors.black,
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        child: screen == "NewPost"
            ? Image.file(File(imagePath))
            : Image.network(imagePath),
      ),
    );
  }
}
