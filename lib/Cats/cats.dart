import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';

import '../drawer.dart';

class CatWidget extends StatefulWidget {
  const CatWidget({Key? key}) : super(key: key);

  @override
  _CatWidgetController createState() => _CatWidgetController();
}

class _CatWidgetController extends State<CatWidget> {
  final baseCatUrl = "https://cataas.com/cat";
  late String imageUrl;

  List<ImageProvider<Object>> likedImages = [];

  String newVersion() {
    return "?v=${DateTime.now().millisecondsSinceEpoch}";
  }

  void handleAcceptData(ImageProvider<Object> value) {
    setState(() {
      likedImages.add(value);
    });
  }

  late ImageProvider<Object> currentImage;

  void setNewCatUrl() {
    setState(() {
      imageUrl = baseCatUrl + newVersion();
      currentImage = NetworkImage(imageUrl);
    });
  }

  @override
  void initState() {
    imageUrl = baseCatUrl + newVersion();
    currentImage = NetworkImage(imageUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _CatWidgetView(this);
}

class _CatWidgetView extends WidgetView<CatWidget, _CatWidgetController> {
  const _CatWidgetView(_CatWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HobbyNavigation(),
      appBar: AppBar(
        title: InkWell(
          onTap: () => Navigator.pushNamed(context, '/'),
          child: const Text("Malte Hviid-Magnussen - Hobby Projects"),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Draggable<ImageProvider<Object>>(
                  data: NetworkImage(state.imageUrl),
                  onDragStarted: () => state.setNewCatUrl(),
                  feedback: Container(
                    height: 320,
                    width: 400,
                    child: CatImageWidget(image: state.currentImage),
                  ),
                  child: CatImageWidget(image: state.currentImage),
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
                      ? CatImageWidget(image: state.likedImages.last)
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

class CatImageWidget extends StatefulWidget {
  const CatImageWidget({Key? key, required this.image}) : super(key: key);
  final ImageProvider<Object> image;

  @override
  _CatImageWidgetController createState() => _CatImageWidgetController();
}

class _CatImageWidgetController extends State<CatImageWidget> {
  @override
  Widget build(BuildContext context) => _CatImageWidgetView(this);
}

class _CatImageWidgetView
    extends WidgetView<CatImageWidget, _CatImageWidgetController> {
  const _CatImageWidgetView(_CatImageWidgetController state) : super(state);

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
