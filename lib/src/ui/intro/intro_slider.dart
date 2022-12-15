import 'package:app/src/ui/intro/intro_slider3.dart';
import 'package:flutter/material.dart';
import 'intro_slider2.dart';

class IntroScreen extends StatefulWidget {
  final Function onFinish;
  const IntroScreen({Key? key, required this.onFinish}) : super(key: key);
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroScreen3(onFinish: widget.onFinish);
  }
}
