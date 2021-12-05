import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'apod_fetch.dart';
import 'apod_model.dart';

import '../drawer.dart';

// https://apodapi.herokuapp.com/
class NasaWidget extends StatefulWidget {
  const NasaWidget({Key? key}) : super(key: key);

  @override
  _NasaWidgetState createState() => _NasaWidgetState();
}

class _NasaWidgetState extends State<NasaWidget> {
  Offset mousePosition = Offset.zero;
  bool isHovering = false;
  late Future<Apod> apod;

  @override
  void initState() {
    apod = fetchAPOD(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const HobbyNavigation(),
      appBar: AppBar(
        title: const Text('NASA Images'),
      ),
      body: SafeArea(
        child: MouseRegion(
          cursor: SystemMouseCursors.none,
          onHover: (PointerHoverEvent details) {
            setState(() {
              mousePosition = details.localPosition;
            });
          },
          child: Stack(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Center(
                  child: FutureBuilder<Apod>(
                    future: apod,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.network(
                          snapshot.data!.hdurl,
                          fit: BoxFit.cover,
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
              Positioned(
                top: mousePosition.dy - 3,
                left: mousePosition.dx - 3,
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: Colors.white,
                  ),
                  width: isHovering ? 50 : 10,
                  height: isHovering ? 50 : 10,
                  duration: const Duration(milliseconds: 200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
