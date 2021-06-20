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
  late String catUrl;

  List<String> likedCats = [];

  String newVersion() {
    return "?v=${DateTime.now().millisecondsSinceEpoch}";
  }

  void handleAcceptData(String value) {
    setState(() {
      likedCats.add(value);
    });
  }

  void setNewCatUrl() {
    setState(() {
      catUrl = baseCatUrl + newVersion();
    });
  }

  @override
  void initState() {
    catUrl = baseCatUrl + newVersion();
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
                child: Draggable<String>(
                  data: state.catUrl,
                  onDragStarted: () => state.setNewCatUrl(),
                  childWhenDragging: CatImageWidget(url: state.catUrl),
                  feedback: Container(
                    height: 300,
                    width: 220,
                    child: CatImageWidget(url: state.catUrl),
                  ),
                  child: CatImageWidget(url: state.catUrl),
                ),
              ),
            ),
          ),
          Expanded(
            child: FractionallySizedBox(
              heightFactor: 0.7,
              child: DragTarget<String>(onAccept: (value) {
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
                  child: state.likedCats.isNotEmpty
                      ? CatImageWidget(url: state.likedCats.last)
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
  const CatImageWidget({Key? key, required this.url}) : super(key: key);
  final String url;

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
          image: NetworkImage(widget.url),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
