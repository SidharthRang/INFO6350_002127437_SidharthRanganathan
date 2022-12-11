import 'dart:io';
import 'package:flutter/material.dart';

class ImageList extends StatelessWidget {
  const ImageList({super.key, required this.images});
  final List<String> images;
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
            child: Image.file(
              File(img),
              fit: BoxFit.cover,
            ),
          )
      ],
    );
  }
}
