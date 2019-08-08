import 'dart:async';
import 'package:etil/home.dart';
import 'package:etil/intro.dart';
import 'package:etil/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ETIL',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: SplashScreen(),
      routes: {
        'splash': (context) => SplashScreen(),
        'home': (context) => HomeScreen()
      },
    );
  }
}


class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('intro_seen') ?? false);
    bool _user = (prefs.getBool("user_data") ?? false);

    if (_seen) {
      if(_user)
      {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new HomeScreen()));
      }
      else
      {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new WelcomeScreen()));
      }
    } else {
      prefs.setBool('intro_seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 1500), () {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Center(
            child: Container(
              alignment: Alignment.center,
              child: Padding(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/images/logo.png"))
                  ),
                ),
                padding: EdgeInsets.only(right: 13),
              ),
            ),
          )
      ),
    );
  }
}
