import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';
import 'package:image_picker/image_picker.dart';

import '../drawer.dart';

// TODO - Make a Trashcan below first image,
//        to make it clear that you can drag away images

// TODO - Allow user to download likedImages[]

// TODO - Add Counter for likedImages[] and nextImages[]

class SortImageWidget extends StatefulWidget {
  const SortImageWidget({Key? key}) : super(key: key);

  @override
  _SortImageWidgetController createState() => _SortImageWidgetController();
}

class _SortImageWidgetController extends State<SortImageWidget> {
  late String imageUrl;

  List<ImageProvider<Object>> nextImages = [];
  List<ImageProvider<Object>> likedImages = [];
  final picker = ImagePicker();

  void dragStarted() {
    setState(() {
      nextImages.removeAt(0);
    });
  }

  bool userHasUploadedPhotos() {
    return nextImages.isNotEmpty;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null && kIsWeb) {
        nextImages.add(NetworkImage(pickedFile.path));
      } else {
        nextImages.add(FileImage(File(pickedFile!.path)));
      }
    });
  }

  String newVersion() {
    return "?v=${DateTime.now().millisecondsSinceEpoch}";
  }

  void handleAcceptData(ImageProvider<Object> value) {
    setState(() {
      likedImages.add(value);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _SortImageWidgetView(this);
}

class _SortImageWidgetView
    extends WidgetView<SortImageWidget, _SortImageWidgetController> {
  const _SortImageWidgetView(_SortImageWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HobbyNavigation(),
      appBar: AppBar(
        title: InkWell(
          onTap: () => Navigator.pushNamed(context, '/'),
          child: const Text("Sort your photos"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Center(child: Icon(Icons.add_a_photo)),
        tooltip: "Upload a Photo",
        onPressed: state.getImage,
        hoverElevation: 10,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: state.userHasUploadedPhotos()
                    ? Draggable<ImageProvider<Object>>(
                        data: state.nextImages.first,
                        onDragStarted: () => state.dragStarted(),
                        feedback: Container(
                          height: kIsWeb ? 320 : 400,
                          width: kIsWeb ? 400 : 320,
                          child:
                              SingleImageWidget(image: state.nextImages.first),
                        ),
                        child: SingleImageWidget(image: state.nextImages.first),
                      )
                    : const Center(
                        child: Text(
                          "Upload your photos, \nto sort them.",
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            child: FractionallySizedBox(
              heightFactor: 0.7,
              child: DragTarget<ImageProvider<Object>>(onAccept: (value) {
                state.handleAcceptData(value);
              }, builder: (_, candidateData, rejectedData) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: state.likedImages.isNotEmpty
                      ? SingleImageWidget(image: state.likedImages.last)
                      : Container(),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class SingleImageWidget extends StatefulWidget {
  const SingleImageWidget({Key? key, required this.image}) : super(key: key);
  final ImageProvider<Object> image;

  @override
  _SingleImageWidgetController createState() => _SingleImageWidgetController();
}

class _SingleImageWidgetController extends State<SingleImageWidget> {
  @override
  Widget build(BuildContext context) => _SingleImageWidgetView(this);
}

class _SingleImageWidgetView
    extends WidgetView<SingleImageWidget, _SingleImageWidgetController> {
  const _SingleImageWidgetView(_SingleImageWidgetController state)
      : super(state);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: widget.image,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}