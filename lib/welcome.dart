
import 'package:etil/config/config.dart';
import 'package:etil/handlers/connection.dart';
import 'package:etil/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/input_tags.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';



class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);


  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  double _fontSize = 14;
  List<String> _inputTags = [];
  int _column = 8;
  bool _withSuggesttions = false;
  bool _symmetry = false;

  @override
  void initState() {
    super.initState();

    _inputTags.addAll(
        [

        ]
    );
  }

  onNextPress() async{
    if(await ConnectionCheck.checkConnection(context) == 1)
    {
      saveData();
      Response response;
      Dio dio = new Dio();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      response = await dio.post("${AppConfig.ip}/api/add", data: {
        "interest": _inputTags,
        "time": new DateTime.now().toString(),
      });

      if(response.statusCode == 200)
      {

        prefs.setString("user_id", response.data["id"]);
        prefs.setBool("user_data", true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
      else
        ConnectionCheck.showAlert(context, "Something went wrong!");
    }
  }



  saveData() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("user_data", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 70),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo_name.png")
                        )
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                child:
                ListView(
                  children: <Widget>[
                    InputTags(
                      placeholder: "Add an intrest",
                      tags: _inputTags,
                      columns: _column,
                      fontSize: _fontSize,
                      symmetry: _symmetry,
                      color: Colors.blue,
                      iconBackground: Colors.blue[800],
                      lowerCase: true,
                      autofocus: true,
                      suggestionsList: !_withSuggesttions ? null :
                      [

                      ],
                      popupMenuBuilder: (String tag){
                        return <PopupMenuEntry>[
                          PopupMenuItem(
                            child: Text(tag,
                              style: TextStyle(
                                  color: Colors.black87,fontWeight: FontWeight.w800
                              ),
                            ),
                            enabled: false,
                          ),
                          PopupMenuDivider(),
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.content_copy,size: 18,),
                                Text(" Copy Text"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.delete,size: 18),
                                Text(" Remove"),
                              ],
                            ),
                          )
                        ];
                      },
                      popupMenuOnSelected: (int id,String tag){
                        switch(id){
                          case 1:
                            Clipboard.setData( ClipboardData(text: tag));
                            break;
                          case 2:
                            setState(() {
                              _inputTags.remove(tag);
                            });
                        }
                      },

                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: FlatButton(
                        highlightColor: Colors.blue,
                        color: Colors.blue[100],
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                        onPressed: onNextPress,
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Container(
                            height: 25,
                            alignment: Alignment.center,
                            width: 150,
                            child: Text("Next", style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 18
                            ),
                            )),
                      ),
                    )
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }

}