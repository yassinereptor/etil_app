import 'package:etil/map.dart';
import 'package:etil/real_visite.dart';
import 'package:etil/vr_visite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:io' show Platform;

import 'handlers/connection.dart';

class DashScreen extends StatefulWidget {

  var data;
  var id;

  DashScreen({Key key, this.data, this.id}) : super(key: key);

  @override
  State<DashScreen> createState() => DashScreenState();
}

class DashScreenState extends State<DashScreen> {

  @override
  void initState() {
    saveHistory();
    super.initState();
  }


  saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = new List();

    if(prefs.containsKey("historyplace"))
      list = prefs.getStringList("historyplace");

    if(!list.contains(widget.id.toString()))
    {
      list.add(widget.id.toString());
      prefs.setStringList("historyplace", list);
    }
  }


  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.info, color: Colors.blue,),
              ),
              Text("Place info"),
            ],
          ),
          content: Container(
            child: Wrap(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 3),
                    child: Row(
                      children: <Widget>[
                        Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Container(
                          child: Text(widget.data["name"]),
                        )
                      ],
                    ),
          ),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                    child: Row(
                      children: <Widget>[
                        Text("Address: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Container(
                          child: Text(widget.data["address"]),
                        )
                      ],
                    ),
        ),
                    Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Row(
                      children: <Widget>[
                        Text("City: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Container(
                          child: Text(widget.data["city"]),
                        )
                      ],
                    ),
                      ),
                    Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Row(
                      children: <Widget>[
                        Text("Region: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Container(
                          child: Text(widget.data["region"]),
                        )
                      ],
                    ),
        ),
                    Container(
                                    margin: EdgeInsets.only(top: 3),
                    child: Row(
                      children: <Widget>[
                        Text("Description: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Container(
                          child: Text(widget.data["description"]),
                        )
                      ],
                    ),
                    ),
                    Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Row(
                      children: <Widget>[
                        Text("Address: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Container(
                          child: Text(widget.data["address"]),
                        )
                      ],
                    ),
                    ),
                  ],
                ),
              ],
            )
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            (widget.data["lat"].toString().isNotEmpty && widget.data["lng"].toString().isNotEmpty)?
            new FlatButton(
              child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(Icons.location_on, color: Colors.blue,),
                ),
              new Text("Map"),

            ],
            ),

              onPressed: () {
                if(widget.data["lat"] != null && widget.data["lng"] != null && widget.data["lat"].toString().isNotEmpty && widget.data["lng"].toString().isNotEmpty)
                {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => new MapScreen(data: widget.data)));
                }else
                  ConnectionCheck.showAlert(context, "Error while loading map");
              },
            ):  Container(),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

//    print("-----------------------------------------");
//    print(widget.data);
//    print("-----------------------------------------");

    return new Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[

            Column(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context) => new RealVisiteScreen()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/images/es1.jpg"), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)),
                      ),
                      child: Center(
                        child: Text("Real Visite", style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),),
                      ),
                    ),
                  )
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      print(widget.data);

                      if(widget.data["image360"] != null && widget.data["image360"].length > 0) {
                        Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (context) => new VrVisiteScreen(
                                  data: widget.data, isIOS: Platform.isIOS)));
                      }
                      else
                        Toast.show("No 360 Images", context, textColor: Colors.black, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM, backgroundColor: Colors.amber);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/images/es2.jpg"), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.lighten)),

                        ),
                        child: Center(
                          child: Text("Virtual Visite", style: TextStyle(
                              fontSize: 40,
                              color: Colors.black

                          ),),
                        )
                    ),
                  )
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 40, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: IconButton(icon: Icon(Icons.arrow_back_ios, size: 30,), color: Colors.white, onPressed: (){
                      Navigator.of(context).pop();
                    }, alignment: Alignment.center),
                  ),
                  Container(
                    child: IconButton(icon: Icon(Icons.info_outline, size: 30,), color: Colors.white, onPressed: (){
                      _showDialog();
                    }, alignment: Alignment.center),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

}