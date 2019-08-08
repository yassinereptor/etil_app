import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:etil/welcome.dart';



class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Complete guide",
        description: "Complete guide of all historical places in morocco with 360 navigation and audio guide",
        backgroundColor: Colors.blue[100],
        centerWidget: Icon(IconData(0xe915, fontFamily: "iconmuse"), color: Colors.white, size: 120,),
        styleTitle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        styleDescription: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );

    slides.add(
      new Slide(
        title: "Easy to use",
        description: "Easy to use with a nice user interface and an excellent user experience."
            "You can enter a musumes without even go to them just at your home",
        backgroundColor: Colors.blue,
        centerWidget: Icon(IconData(0xe914, fontFamily: "iconmuse"), color: Colors.white, size: 120,),
        styleTitle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        styleDescription: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );

    slides.add(
      new Slide(
        title: "Audio Guide",
        description: "Multilanguage audio guides with a brief history about all the historical places",
        backgroundColor: Color(0xffec407a),
        centerWidget: Icon(IconData(0xe900, fontFamily: "iconmuse"), color: Colors.white, size: 120,),
        styleTitle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        styleDescription: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  Future onDonePress() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}
