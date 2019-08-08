import 'dart:async';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'config/config.dart';
import 'dash.dart';

class NearbyScreen extends StatefulWidget {


  @override
  State<NearbyScreen> createState() => NearbyScreenState();
}

class NearbyScreenState extends State<NearbyScreen> {
  Completer<GoogleMapController> _controller = Completer();
  static LatLng latlng;
  Position pos;

    CameraPosition _kGooglePlex = CameraPosition(
  target: new LatLng(20.785834, 10),
  zoom: 14.4746,
  );

  final Set<Marker> _markers = Set();
  initPos()
  async {
    print("Am here");
    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((p){
      pos = p;
      print(pos);
      if(pos == null)
      {
        Toast.show("No location found", context, textColor: Colors.black, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM, backgroundColor: Colors.amber);
        Navigator.pop(context);
      }
      else {
        setState(() {
          latlng = new LatLng(pos.latitude,pos.longitude);
          getPos();
          _kGooglePlex = CameraPosition(
            target: latlng,
            zoom: 14.4746,
          );
        });
      }
    });

  }


  getPlaces()
  {
    Dio().get("${AppConfig.ip}/api/places").then((data){
      if(data.statusCode == 200)
      {
        var list = data.data;
        list.forEach((item){
          if(item["lat"] != null && item["lat"] != null && item["name"] != null)
          {
            if(mounted)
            {
              setState(() {
                _markers.add(new Marker(
                  onTap: () async {
                    print(item);
                    Response res = await new Dio().get(
                        "${AppConfig.ip}/api/place-get", queryParameters: {
                      "serieID": item["serie"]
                    });

                    if(res.statusCode == 200)
                    {

                      Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context) => new DashScreen(data: res.data[0],)));
                    }
                  },
                  markerId: MarkerId(item["name"]),
                  position: new LatLng(double.parse(item["lat"].toString()), double.parse(item["lng"].toString())),
                ));
              });
            }
          }
        });
      }
    });
  }

  @override
  void initState() {
    initPos();
    getPlaces();
    super.initState();
  }

  getPos()async
  {

    String name = "My location";

    _markers.add(Marker(
      markerId: MarkerId(name),
      position: latlng,
    ));
    final CameraPosition _pos = CameraPosition(
        bearing: 192.8334901395799,
        target: latlng,
//        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_pos));
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Near by"),
          centerTitle: false,
          leading: IconButton(icon:Icon(Icons.arrow_back_ios),
            onPressed:() => Navigator.pop(context),
          )),

      body: GoogleMap(
        mapType: MapType.hybrid,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: true,
        markers: _markers,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

}