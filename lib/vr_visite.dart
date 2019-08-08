import 'package:dio/dio.dart';
import 'package:etil/config/config.dart';
import 'package:etil/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vrview/vrview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VrVisiteScreen extends StatefulWidget {

  var data;
  bool isIOS;

  VrVisiteScreen({Key key, this.data, this.isIOS}) : super(key: key);

  @override
  State<VrVisiteScreen> createState() => _VrVisiteScreenState();
}

class _VrVisiteScreenState extends State<VrVisiteScreen> {
  VrController vrController;
//  static var data;
  List<bool> plays = new List();

  Vrview vr;

  stopAll()
  {
    int i = 0;
    widget.data["image360"].forEach((d){
      plays[i++] = false;
    });
  }

  
  @override
  void initState() {


    plays = List(widget.data["image360"].length);
    stopAll();
    super.initState();

  }



//  showImage(link) async{
//
//
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return Dialog(
//          child: Container(
//            decoration: BoxDecoration(
////              borderRadius: BorderRadius.all(Radius.circular(10)),
//
//            ),
//              child: Wrap(
//                children: <Widget>[
//                  Container(
//                      width: MediaQuery.of(context).size.width,
//
//                      decoration: BoxDecoration(
////                        borderRadius: BorderRadius.all(Radius.circular(10)),
//
//                      ),
//                      child:
//                  )
//                ],
//              )
//          ),
//        );
//      },
//    );
//  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
          title: Text(widget.data["name"]),
          leading: IconButton(icon:Icon(Icons.arrow_back_ios),
            onPressed:() => Navigator.pop(context),
          )),

      body: Container(
        padding: EdgeInsets.only(top: 10 , bottom: 10),
        child: ScrollConfiguration(behavior: ScrollBehaviorCos(), child:ListView.builder(
            itemCount: widget.data["image360"].length,
            itemBuilder: (context, i){
              vr = new Vrview(
                onVrCreated: (vrController){
                  this.vrController = vrController;
                  //        this.vrController.loadUrl("https://b.imge.to/2019/07/17/LmEy0.jpg");
                  this.vrController.loadUrl(widget.data["image360"][i]);
                },
              );

              return Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: AspectRatio(
                    aspectRatio: 16/9,
                    child: Stack(
                      children: <Widget>[
                        !plays[i]?
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, offset: Offset.zero, blurRadius: 2, spreadRadius: 0),
                              ],
                              image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(widget.data["image360"][i]))
                          ),
                        ):
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, offset: Offset.zero, blurRadius: 2, spreadRadius: 0),
                            ],
                          ),
                          child: !widget.isIOS? vr : Container(
                            child: WebView(
                              onPageFinished: (_){
                                print("Loaded");
                              },
                              javascriptMode: JavascriptMode.unrestricted,
                              initialUrl: "http://167.71.71.230:8081/index.html",
                            ),
                          )
                        ),
                      (plays[i] && widget.isIOS )?
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (context) => new VrFullScreen()));
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.bottomRight,
                            child: Icon(Icons.fullscreen, color: Colors.white, size: 27,),
                          ),
                        ):Container(),
                        !plays[i] ?
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              stopAll();
                              plays[i] = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.bottomRight,
                            child: Icon(Icons.play_arrow, color: Colors.white, size: 27,),
                          ),
                        ) :
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              plays[i] = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.topLeft,
                            child: Icon(Icons.stop, color: Colors.white, size: 27,),
                          ),
                        )
                      ],
                    )
                ),
              );
            }
        )),

      ),
//      body: Container(
//        child: vr,
//        height: 300.0,
//      ),
    );
  }


}



class VrFullScreen extends StatefulWidget {


  VrFullScreen({Key key}) : super(key: key);

  @override
  State<VrFullScreen> createState() => _VrFullScreenState();
}

class _VrFullScreenState extends State<VrFullScreen> {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          WebView(
            onPageFinished: (_){
              print("Loaded");
            },
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: "http://167.71.71.230:8081/index.html",
          ),
          Container(),
        ],
      ),
    );
  }

}