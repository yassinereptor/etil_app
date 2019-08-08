import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:etil/config/config.dart';
import 'package:etil/handlers/connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hex/hex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'article.dart';
import 'history.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart' as Qr;

import 'qr.dart';

class GuideScreen extends StatefulWidget {

  var data;

  GuideScreen({Key key, this.data}) : super(key: key);

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {

  var list;
  var obj;
  FlutterBlue flutterBlue = FlutterBlue.instance;



  getDis(Beacon b) {
    var res;
    int n = 2;
    res = pow(10, ((b.txPower - b.rssi) / (10 * n))) * b.accuracy;
    return (res >= 0 ? res : 0);
  }

  beaconInit() async
  {
    try {
      await flutterBeacon.initializeScanning;
      final regions = <Region>[];

      if (Platform.isIOS) {
        regions.add(Region(
            identifier: 'Apple Airlocate',
            proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
      } else {
        // android platform, it can ranging out of beacon that filter all of Proximity UUID
        regions.add(Region(identifier: 'com.beacon'));
      }

      Stream<RangingResult> sub = flutterBeacon.ranging(regions);

      sub.take(10).listen((RangingResult result) {
        list.clear();
        obj.clear();
//        result.beacons.forEach((b) async {
//          if (await ConnectionCheck.checkConnection(context) == 1) {
//            Dio().get("${AppConfig.ip}/api/article/${getID(b)}").then((data) {
//              if (data.statusCode == 200) {
//                print(data.data);
//                if (mounted) {
//                  setState(() {
//                    obj.add(data.data[0]);
//                    list.add(b);
//                  });
//                }
//              }
//            });
//          }
//        });

        var ids  = result.beacons.map((b)=> getID(b)).toList();
        if(ids.length > 0){
          print("-------------------------------------------------");
          print("-----------------------$ids--------------------------");
          print("-------------------------------------------------");
          Dio().post("${AppConfig.ip}/api/article-list", data: {
            "serieID": ids
          }).then((data){
            if (data.statusCode == 200) {
              print(data.data);
              if (mounted) {
                setState(() {
                  obj = data.data;
                  list = result.beacons.map((b)=> b).toList();
                });
              }
            }
          });
          print("JSON: ${obj}");
        }



      });
    } catch (PlatformException) {
      // library failed to initialize, check code and message
    }
  }

  bool bt = false;
  bool scan_bt = false;


  testHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = new List();

    String id = "636F3F8F64914BEE95F7D8CC64A863B50000";

    if(prefs.containsKey("history"))
      list = prefs.getStringList("history");

    if(!list.contains(id))
    {
      list.add(id);
      prefs.setStringList("history", list);
    }
  }

  @override
  void initState() {
    list = new List();
    obj = new List();


    if(Platform.isIOS)
      testHistory();


    if (mounted)
      setState(() {
        onBluePress();
      });
    super.initState();
    iconData = Icons.bluetooth;
    flutterBlue.state.listen((b) {
      switch (b)
      {
        case BluetoothState.unknown:
          break;
        case BluetoothState.unavailable:
          // TODO: Handle this case.
          break;
        case BluetoothState.unauthorized:
          // TODO: Handle this case.
          break;
        case BluetoothState.turningOn:
          // TODO: Handle this case.
          break;
        case BluetoothState.turningOff:
          // TODO: Handle this case.
          break;
        case BluetoothState.off:
          setState(() {
            print("Off");
            bt = false;
          });
          break;
        case BluetoothState.on:
          setState(() {
            print("On");
            bt = true;
          });
          break;
      }
    });
  }

  getID(Beacon b) {
    String uuid = b.proximityUUID.replaceAll('-', '');
    String major_minor = HEX.encode([b.major, b.minor]);
    String res = uuid + major_minor;
    return res;
  }

  IconData iconData;


  onBluePress()
  {

    Timer time = Timer.periodic(new Duration(milliseconds: 200), (_){
      setState(() {
        if(iconData == Icons.bluetooth)
          iconData = Icons.bluetooth_searching;
        else
          iconData = Icons.bluetooth;
      });
    });
    Timer(new Duration(seconds: 5), (){
      setState(() {
        iconData = Icons.bluetooth;
      });
      if (mounted)
        setState(() {
          beaconInit();
        });
      time.cancel();
    });
  }


  showHis()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> his = new List();
    if(prefs.containsKey("history"))
    {
      his = prefs.getStringList("history");

      if (await ConnectionCheck.checkConnection(context) == 1) {
        Dio().post("${AppConfig.ip}/api/article-list", data: {
          "serieID": his
        }).then((data) {
          if (data.statusCode == 200) {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new HistoryScreen(data: data.data, his: his,)));
          }
        });
      }
    }

  }

  scanQr()async{
    List<Qr.CameraDescription> cameras = await Qr.availableCameras();

    if(cameras.length > 0)
    {

      PermissionHandler().requestPermissions([PermissionGroup.camera]).then((res){
        res.forEach((g, s) async {
          // ignore: ambiguous_import
          if(g == PermissionGroup.camera && s == PermissionStatus.granted)
          {

            var data = await Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new QrScreen(cameras: cameras)));
            Response res = await new Dio().get(
                "${AppConfig.ip}/api/article/$data");
            if(res.statusCode == 200)
            {
              
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => new ArticleScreen(data: res.data[0],)));
            }
            else ConnectionCheck.showAlert(context, "QR invalide");
          }
        });
      });

    }
    else
      ConnectionCheck.showAlert(context, "Camera error");
  }


  Timer p_timer;
  bool bol;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20, right: 30, top: 10, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      onPressed: (){
                        showHis();
                      },
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      child: Container(
                          height: 25,
                          alignment: Alignment.center,
                          child: Text("History", style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18
                          ),
                          )),
                    ),
                  ),
                  Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(icon: Icon(Icons.center_focus_weak, size: 22, color: Colors.white,), onPressed: scanQr),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bt? Colors.blue : Colors.red,
                      ),
                      child: IconButton(icon: Icon(bt? iconData : Icons.bluetooth_disabled, size: 22, color: Colors.white,), onPressed: onBluePress),
                    )
                  ],)
                ],
              ),
            ),
            Divider(),
            Padding(padding: EdgeInsets.only(bottom: 10),),
            ListView.builder(
              shrinkWrap: true,
              itemCount: obj.length,
              itemBuilder: (context, i){
                return GestureDetector(
                  onTap: ()async {

                    bol = false;
                    Toast.show("Loading data ...", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.blue);

                     p_timer = Timer.periodic(new Duration(milliseconds: 100), (_) async {
                       Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
                       PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
                      if(obj.length > 0 && obj[i] != null && permission == PermissionStatus.granted)
                      {
                        p_timer.cancel();
                        bol = true;
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new ArticleScreen(data: obj[i], id: getID(list[i]))));
                      }
                    });
                    Timer(new Duration(seconds: 10), (){
                      p_timer.cancel();
                      if(!bol)
                      {
                        Toast.show("Timeout !! Check Connection", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.blue);
                        ConnectionCheck.checkConnection(context);
                      }
                    });
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
                            if(obj.length > 0 && obj[i] != null)
                            {
                              Navigator.of(context).push(MaterialPageRoute<void>(
                                  builder: (BuildContext context)=> PhotoHero(link: obj[i]["image"], tag: "${i}",)
                              ));
                            }
                          },
                          child: Hero(tag: "${i}", child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: (obj.length > 0 && obj[i] != null)? CachedNetworkImageProvider(obj[i]["image"]) : AssetImage("assets/images/logo.png")
                              ),
                            ),
                          ),),
                        ),
                        Expanded(child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text((obj.length > 0 && obj[i] != null)? obj[i]["name"] : "Untitled", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text("Dis: ${getDis(list[i]).toStringAsFixed(2)} m"),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text((obj.length > 0 && obj[i] != null)? obj[i]["place"] : "No place", style: TextStyle(fontSize: 16),),
                              )

                            ],
                          ),
                        ))
                      ],
                    )
                  ),
                );
              },
            ),
          ],
        )
      ),
    );
  }

}


class PhotoHero extends StatefulWidget {

  String link;
  String tag;
  PhotoHero({@required this.link, this.tag});

  @override
  _PhotoHeroState createState() => _PhotoHeroState();
}

class _PhotoHeroState extends State<PhotoHero> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
              color: Colors.white
          ),
        ),
        body: Container(
          color: Colors.black,
          child: Container(
            // The blue background emphasizes that it's a new route.
              alignment: Alignment.center,
              child: Hero(
                tag: widget.tag,
                child: PhotoView(
                  imageProvider: CachedNetworkImageProvider(widget.link),
                ),
              )
          ),
        )
    );
  }
}