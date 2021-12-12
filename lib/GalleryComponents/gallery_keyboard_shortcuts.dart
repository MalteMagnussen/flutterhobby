import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NextPageIntent extends Intent {
  const NextPageIntent();
}

class PreviousPageIntent extends Intent {
  const PreviousPageIntent();
}

class GalleryKeyboardShortcuts extends StatelessWidget {
  const GalleryKeyboardShortcuts({
    Key? key,
    required this.child,
    required this.pageController,
  }) : super(key: key);
  final Widget child;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.arrowRight): const NextPageIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): const PreviousPageIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          NextPageIntent: CallbackAction<NextPageIntent>(
            onInvoke: (NextPageIntent intent) => pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease),
          ),
          PreviousPageIntent: CallbackAction<PreviousPageIntent>(
            onInvoke: (PreviousPageIntent intent) =>
                pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease),
          ),
        },
        child: child,
      ),
    );
  }
}
