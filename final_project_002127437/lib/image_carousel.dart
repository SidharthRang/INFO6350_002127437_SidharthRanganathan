import 'dart:io';
import 'package:flutter/material.dart';

class ImageList extends StatelessWidget {
  const ImageList({super.key, required this.images, required this.activity});
  final List<dynamic> images;
  final String activity;
  final int activePage = 1;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return PageView(
      controller: controller,
      children: <Widget>[
        for (var img in images)
          Padding(
            padding: const EdgeInsets.all(20),
            child: activity == "NewPost"
                ? Image.file(
                    File(img.toString()),
                    fit: BoxFit.cover,
                  )
                : Image.network(img.toString(), fit: BoxFit.cover),
          )
      ],
    );
  }
}
