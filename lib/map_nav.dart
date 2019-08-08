import 'package:flutter/material.dart';

class MapNavScreen extends StatefulWidget {

  var data;

  MapNavScreen({Key key, this.data}) : super(key: key);

  @override
  State<MapNavScreen> createState() => _MapNavScreenState();
}

class _MapNavScreenState extends State<MapNavScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
//        height: MediaQuery.of(context).size.height,
//        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/map.png"), fit: BoxFit.cover)
        ),
      ),
    );
  }

}