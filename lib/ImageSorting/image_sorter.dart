import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';
import 'package:image_picker/image_picker.dart';

import '../drawer.dart';

class SortImageWidget extends StatefulWidget {
  const SortImageWidget({Key? key}) : super(key: key);

  @override
  _SortImageWidgetController createState() => _SortImageWidgetController();
}

class _SortImageWidgetController extends State<SortImageWidget> {
  late String imageUrl;

  // https://api.nasa.gov/
  List<ImageProvider<Object>> nextImages = [];
  List<ImageProvider<Object>> likedImages = [];
  final picker = ImagePicker();

  void dragStarted() {
    setState(() {
      nextImages.removeAt(0);
    });
  }

  ImageProvider<Object> nextImage() {
    return nextImages.first;
  }

  bool userHasUploadedPhotos() {
    return nextImages.isNotEmpty;
  }

  Future getImage() async {
    List<PickedFile>? pickedFiles = await picker.getMultiImage();

    setState(() {
      for (var pickedFile in pickedFiles!) {
        if (kIsWeb) {
          nextImages.add(NetworkImage(pickedFile.path));
        } else {
          File _tmpFile = File(pickedFile.path);
          nextImages.add(FileImage(_tmpFile));
        }
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
      endDrawer: const HobbyNavigation(),
      appBar: AppBar(
        title: const Text("Sort your photos"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const FloatingActionButton(
            backgroundColor: Colors.white,
            child: Center(child: Icon(Icons.delete)),
            tooltip: "Delete unused images",
            onPressed: null,
            hoverElevation: 10,
            heroTag: null,
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.white,
            child: const Center(child: Icon(Icons.add_a_photo)),
            tooltip: "Upload a Photo",
            onPressed: state.getImage,
            hoverElevation: 10,
            heroTag: null,
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: FractionallySizedBox(
                    heightFactor: 0.8,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: state.userHasUploadedPhotos()
                          ? Draggable<ImageProvider<Object>>(
                              data: state.nextImage(),
                              onDragStarted: () => state.dragStarted(),
                              feedback: SizedBox(
                                height: kIsWeb ? 320 : 400,
                                width: kIsWeb ? 400 : 320,
                                child:
                                    SingleImageWidget(image: state.nextImage()),
                              ),
                              child:
                                  SingleImageWidget(image: state.nextImage()),
                            )
                          : const Center(
                              child: Text(
                                "Upload your photos, \nto sort them."
                                "\n\n"
                                "Drag images to "
                                "\nthe right to keep them."
                                "\n\n"
                                "Images not in the pile\n"
                                "will be discarded.\n\n"
                                "This doesn't work on Web yet.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                  ),
                ),
                state.userHasUploadedPhotos()
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("1 of ${state.nextImages.length}"),
                      )
                    : Container(),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: FractionallySizedBox(
                    heightFactor: 0.8,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Kept images: ${state.likedImages.length}"),
                ),
              ],
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
