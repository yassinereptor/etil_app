import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'config/config.dart';
import 'dash.dart';
import 'guide.dart' as GU;
import 'article.dart';
import 'handlers/connection.dart';
import 'map.dart';

class HistoryPlaceScreen extends StatefulWidget {

  var data;
  var his;

  HistoryPlaceScreen({Key key, this.data, this.his}) : super(key: key);

  @override
  State<HistoryPlaceScreen> createState() => _HistoryPlaceScreenState();
}

class _HistoryPlaceScreenState extends State<HistoryPlaceScreen> {


  Timer p_timer;
  bool bol;

  @override
  void initState() {
    print(widget.his);
    print(widget.data);
    print( widget.data.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Places History"),
      ),
      body: Container(
        child:
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.data.length,
          itemBuilder: (context, i){
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: Key(widget.his[i].toString()),
              onDismissed: (direction) {
                 setState(() async {
                    widget.data.removeAt(i);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    List<String> tmp = new List();
                      if(prefs.containsKey("historyplace"))
                      {
                          tmp = prefs.getStringList("historyplace");
                          tmp.removeAt(i);
                          prefs.setStringList("historyplace", tmp);
                      }
                  });
                  Toast.show("Item deleted !", context, textColor: Colors.black, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.amber);
              },
              background: Icon(Icons.delete_sweep, size: 30, color: Colors.red,),
              child: Container(
                child: GestureDetector(
                  onTap: ()async {

                    bol = false;
                    Toast.show("Loading data ...", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM, backgroundColor: Colors.blue);
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new DashScreen(data: widget.data[i], id: widget.his[i])));
//                    p_timer = Timer.periodic(new Duration(milliseconds: 100), (_) async {
//                      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
//                      PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
//                      if((widget.data.length > 0 && widget.data[i] != null) && permission == PermissionStatus.granted)
//                      {
//                        p_timer.cancel();
//                        bol = true;
//                        Navigator.of(context).push(new MaterialPageRoute(
//                            builder: (context) => new DashScreen(data: widget.data[i], id: widget.his[i])));
//                      }
//                    });
//                    Timer(new Duration(seconds: 10), (){
//                      p_timer.cancel();
//                      if(!bol)
//                      {
//                        Toast.show("Timeout !! Check Connection", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.blue);
//                        ConnectionCheck.checkConnection(context);
//                      }
//                    });
                  },
                  child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, offset: Offset.zero, blurRadius: 2, spreadRadius: 0),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap:(){
                              if(widget.data.length > 0 && widget.data[i] != null)
                              {
//                                Navigator.of(context).push(MaterialPageRoute<void>(
//                                    builder: (BuildContext context)=> GU.PhotoHero(link: widget.data[i]["image"], tag: "${i}",)
//                                ));
                                if(widget.data[i]["lat"] != null && widget.data[i]["lng"] != null && widget.data[i]["lat"].toString().isNotEmpty && widget.data[i]["lng"].toString().isNotEmpty)
                                {
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(builder: (context) => new MapScreen(data: widget.data[i])));
                                }else
                                  ConnectionCheck.showAlert(context, "Error while loading map");
                              }
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              child: Icon(Icons.location_on, color: Colors.blue,),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Expanded(child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text((widget.data.length > 0 && widget.data[i] != null)? widget.data[i]["name"] : "Untitled", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text((widget.data.length > 0 && widget.data[i] != null)? widget.data[i]["address"] : "No Address", style: TextStyle(fontSize: 16),),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text((widget.data.length > 0 && widget.data[i] != null)? widget.data[i]["city"] : "No City", style: TextStyle(fontSize: 16),),
                                )
                              ],
                            ),
                          ))
                        ],
                      )
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}