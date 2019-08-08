import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {

  var data;

  MapScreen({this.data});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  static LatLng latlng;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: latlng,
    zoom: 14.4746,
  );

  final Set<Marker> _markers = Set();

  @override
  void initState() {
    latlng = new LatLng(double.parse(widget.data["lat"]), double.parse(widget.data["lng"]));
    getPos();
    super.initState();
  }

  getPos()async
  {

    String name = widget.data["name"];

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
          title: Text(widget.data["name"]),
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