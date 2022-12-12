import 'dart:io';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'display_picture.dart';

class ImageList extends StatefulWidget {
  const ImageList({super.key, required this.images, required this.activity});
  final List<dynamic> images;
  final String activity;

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  final ValueNotifier<int> _pageNotifier = ValueNotifier<int>(0);
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: controller,
            children: <Widget>[
              for (var img in widget.images)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            imagePath: img.toString(),
                            imageTitle: "Image ${_pageNotifier.value + 1}",
                            screen: widget.activity,
                          ),
                        ),
                      );
                    },
                    child: widget.activity == "NewPost"
                        ? Image.file(
                            File(img.toString()),
                            fit: BoxFit.cover,
                          )
                        : Image.network(img.toString(), fit: BoxFit.cover),
                  ),
                )
            ],
            onPageChanged: (index) {
              setState(() {
                _pageNotifier.value = index;
              });
            },
          ),
        ),
        Center(
          child: CirclePageIndicator(
            currentPageNotifier: _pageNotifier,
            itemCount: widget.images.length,
          ),
        ),
      ],
    );
  }
}
