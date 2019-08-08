import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import 'guide.dart';
import 'map_nav.dart';
import 'settings.dart';

class RealVisiteScreen extends StatefulWidget {

  var data;

  RealVisiteScreen({Key key, this.data}) : super(key: key);

  @override
  State<RealVisiteScreen> createState() => _RealVisiteScreenState();
}

class _RealVisiteScreenState extends State<RealVisiteScreen> {



  int currentPage = 0;

  getScreen(){
    switch(currentPage)
    {
      case 0: return MapNavScreen(); break;
      case 1: return GuideScreen(); break;
      case 2: return SettingsScreen(); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          flexibleSpace: Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/logo_name.png"))
            ),),
          leading: IconButton(icon:Icon(Icons.arrow_back_ios),
            onPressed:() => Navigator.pop(context),
          )),

      bottomNavigationBar: FancyBottomNavigation(
        initialSelection: 0,
          activeIconColor: Colors.white,
          inactiveIconColor: Colors.grey,
          circleColor: Colors.blue,
          tabs: [
            TabData(iconData: Icons.map, title: "Map"),
            TabData(iconData: Icons.search, title: "Guide"),
            TabData(iconData: Icons.settings, title: "Settings")
          ],
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ),
      body: getScreen(),
    );
  }

}