import 'package:app/grocery_ui/widgets/clipers.dart';
import 'package:flutter/material.dart';

class ClipArtBackground extends StatelessWidget {
  final Widget child;
  const ClipArtBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              color: Colors.greenAccent[100],
            ),
          ),
        ),
        child
      ],
    );
  }
}
