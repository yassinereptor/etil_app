import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {

  var data;

  SettingsScreen({Key key, this.data}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(),
    );
  }
}