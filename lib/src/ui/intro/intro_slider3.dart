import 'package:flex_color_scheme/src/flex_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:lottie/lottie.dart';

class IntroScreen3 extends StatefulWidget {
  final Function onFinish;
  IntroScreen3({Key? key, required this.onFinish}) : super(key: key);

  @override
  IntroScreen3State createState() => new IntroScreen3State();
}

class IntroScreen3State extends State<IntroScreen3> {
  List<Slide> slides = [];

  Color descriptionColor = Color(0xff000000);
  Color tittleColor = Color(0xff000000);
  Color backGroundColor = Color(0xffffffff);
  Color buttonColor = Color(0xffffffff);
  Color buttonIconColor = Color(0xff000000);
  Color colorDot = Colors.black12;
  Color colorActiveDot = Color(0xff000000);


/*Color descriptionColor = Color(0xffffffff);
  Color tittleColor = Color(0xffffffff);
  Color backGroundColor = Color(0xff01a085);
  Color buttonColor = Color(0xffffffff);
  Color buttonIconColor = Color(0xff01a085);
  Color colorDot = Colors.black12;
  Color colorActiveDot = Color(0xffffffff);*/

  @override
  void initState() {
    super.initState();
  }

  void onDonePress() {
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
    child: new IntroSlider(
    //backgroundColorAllSlides: Theme.of(context).colorScheme.primary,
    colorDot: colorDot,
    colorActiveDot: colorActiveDot,
      slides: [
        Slide(
          title: "Online Shopping",
          styleTitle: TextStyle(
              color: tittleColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono'),
          description:
          "Shop Electronics, Mobile, Men Clothing, Women Clothing, Home appliances & Kitchen appliances online now.",
          styleDescription: TextStyle(
              color: descriptionColor,
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway'),
          centerWidget: Lottie.asset("assets/images/intro/lottie1.json"),
          backgroundColor: backGroundColor,
        ),
        Slide(
          title: "Best offers always",
          styleTitle: TextStyle(
              color: tittleColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono'),
          description:
          "Avail offers on most products. Get Great Offers, Discounts and Deals",
          styleDescription: TextStyle(
              color: descriptionColor,
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway'),
          centerWidget: Lottie.asset("assets/images/intro/lottie2.json"),
          backgroundColor: backGroundColor,
        ),
        Slide(
          title: "Handpicked Products",
          styleTitle: TextStyle(
              color: tittleColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono'),
          description:
          "Handpicked products at a discounted price. Save on wide range of categories",
          styleDescription: TextStyle(
              color: descriptionColor,
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway'),
          centerWidget: Lottie.asset("assets/images/intro/lottie3.json"),
          backgroundColor: backGroundColor,
        )
      ],
      onDonePress: this.onDonePress,
      //backgroundColorAllSlides: backGroundColor,
      renderNextBtn: Text('Next'),
      renderSkipBtn: Text('Skip'),
      renderDoneBtn: Text('Done'),
      renderPrevBtn: Text('Prev'),
      //onDonePress: this.onDonePress,
      ),
    );
  }
}