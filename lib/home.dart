
import 'package:dio/dio.dart';
import 'package:etil/config/config.dart';
import 'package:etil/dash.dart';
import 'package:etil/map.dart';
import 'package:etil/qr.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart' as Qr;
import 'package:geolocator/geolocator.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:etil/handlers/connection.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'history_place.dart';
import 'nearby.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

//  var screenCurrent;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
      isDraggable: true,
      menu: Menu(),
      screenSelectedBuilder: (position, controller) {
//        Widget screenCurrent;
        bool hideMap = true;
//        Widget screenCurrent;

//        switch(position){
//          case 1 : getNearby(); break;
//          case 2 : screenCurrent = null; break;
//        }
        print(hideMap);

        return HomeInside(toggle: controller.toggle);

      },
    );

  }

}

class HomeInside extends StatefulWidget {

  Function toggle;
  HomeInside({Key key, this.toggle}) : super(key: key);

  @override
  _HomeInsideState createState() => _HomeInsideState();

}
class _HomeInsideState extends State<HomeInside>
{


  final TextEditingController _city_controller = new TextEditingController();
  final TextEditingController _nom_controller = new TextEditingController();
  bool focus = false;
  List<ScreenHiddenDrawer> items = new List();

  onLocationPress(){
    if(_city_controller.text.isNotEmpty && _nom_controller.text.isNotEmpty && places_sug.contains(_nom_controller.text))
    {
      var data = places.firstWhere((i){
        return i["name"] == _nom_controller.text;
      });

      if(data["lat"] != null && data["lng"] != null && data["lat"].toString().isNotEmpty && data["lng"].toString().isNotEmpty)
      {
        print(data);
        Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) => new MapScreen(data: data)));
      }else
        ConnectionCheck.showAlert(context, "Error while loading map");

    }
  }

  onSearchPress() async{
    if(await ConnectionCheck.checkConnection(context) == 1)
    {

      if(_city_controller.text.isNotEmpty && _nom_controller.text.isNotEmpty && places_sug.contains(_nom_controller.text) && list.contains(_city_controller.text))
      {
        var data = places.firstWhere((i){
          return i["name"] == _nom_controller.text;
        });

        Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) => new DashScreen(data: data, id: data["serie"])));
      }
      else
        ConnectionCheck.showAlert(context, "Fill the fields");
    }
  }


  String currentText = "";
  String currentName = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key2 = new GlobalKey();
  List<String> names = [];
  List<String> list = [
    "Aïn Harrouda",
    "Ben Yakhlef",
    "Bouskoura",
    "Casablanca",
    "Médiouna",
    "Mohammadia",
    "Tit Mellil",
    "Ben Yakhlef",
    "Bejaâd",
    "Ben Ahmed",
    "Benslimane",
    "Berrechid",
    "Boujniba",
    "Boulanouare",
    "Bouznika",
    "Deroua",
    "El Borouj",
    "El Gara",
    "Guisser",
    "Hattane",
    "Khouribga",
    "Loulad",
    "Oued Zem",
    "Oulad Abbou",
    "Oulad H'Riz Sahel",
    "Oulad M'rah",
    "Oulad Saïd",
    "Oulad Sidi Ben Daoud",
    "Ras El Aïn",
    "Settat",
    "Sidi Rahhal Chataï",
    "Soualem",
    "Azemmour",
    "Bir Jdid",
    "Bouguedra",
    "Echemmaia",
    "El Jadida",
    "Hrara",
    "Ighoud",
    "Jamâat Shaim",
    "Jorf Lasfar",
    "Khemis Zemamra",
    "Laaounate",
    "Moulay Abdallah",
    "Oualidia",
    "Oulad Amrane",
    "Oulad Frej",
    "Oulad Ghadbane",
    "Safi",
    "Sebt El Maârif",
    "Sebt Gzoula",
    "Sidi Ahmed",
    "Sidi Ali Ban Hamdouche",
    "Sidi Bennour",
    "Sidi Bouzid",
    "Sidi Smaïl",
    "Youssoufia",
    "Fès",
    "Aïn Cheggag",
    "Bhalil",
    "Boulemane",
    "El Menzel",
    "Guigou",
    "Imouzzer Kandar",
    "Imouzzer Marmoucha",
    "Missour",
    "Moulay Yaâcoub",
    "Ouled Tayeb",
    "Outat El Haj",
    "Ribate El Kheir",
    "Séfrou",
    "Skhinate",
    "Tafajight",
    "Arbaoua",
    "Aïn Dorij",
    "Dar Gueddari",
    "Had Kourt",
    "Jorf El Melha",
    "Kénitra",
    "Khenichet",
    "Lalla Mimouna",
    "Mechra Bel Ksiri",
    "Mehdia",
    "Moulay Bousselham",
    "Sidi Allal Tazi",
    "Sidi Kacem",
    "Sidi Slimane",
    "Sidi Taibi",
    "Sidi Yahya El Gharb",
    "Souk El Arbaa",
    "Akka",
    "Assa",
    "Bouizakarne",
    "El Ouatia",
    "Es-Semara",
    "Fam El Hisn",
    "Foum Zguid",
    "Guelmim",
    "Taghjijt",
    "Tan-Tan",
    "Tata",
    "Zag",
    "Marrakech",
    "Ait Daoud",
    "Amizmiz",
    "Assahrij",
    "Aït Ourir",
    "Ben Guerir",
    "Chichaoua",
    "El Hanchane",
    "El Kelaâ des Sraghna",
    "Essaouira",
    "Fraïta",
    "Ghmate",
    "Ighounane",
    "Imintanoute",
    "Kattara",
    "Lalla Takerkoust",
    "Loudaya",
    "Lâattaouia",
    "Moulay Brahim",
    "Mzouda",
    "Ounagha",
    "Sid L'Mokhtar",
    "Sid Zouin",
    "Sidi Abdallah Ghiat",
    "Sidi Bou Othmane",
    "Sidi Rahhal",
    "Skhour Rehamna",
    "Smimou",
    "Tafetachte",
    "Tahannaout",
    "Talmest",
    "Tamallalt",
    "Tamanar",
    "Tamansourt",
    "Tameslouht",
    "Tanalt",
    "Zeubelemok",
    "Meknès‎",
    "Khénifra",
    "Agourai",
    "Ain Taoujdate",
    "MyAliCherif",
    "Rissani",
    "Amalou Ighriben",
    "Aoufous",
    "Arfoud",
    "Azrou",
    "Aïn Jemaa",
    "Aïn Karma",
    "Aïn Leuh",
    "Aït Boubidmane",
    "Aït Ishaq",
    "Boudnib",
    "Boufakrane",
    "Boumia",
    "El Hajeb",
    "Elkbab",
    "Er-Rich",
    "Errachidia",
    "Gardmit",
    "Goulmima",
    "Gourrama",
    "Had Bouhssoussen",
    "Haj Kaddour",
    "Ifrane",
    "Itzer",
    "Jorf",
    "Kehf Nsour",
    "Kerrouchen",
    "M'haya",
    "M'rirt",
    "Midelt",
    "Moulay Ali Cherif",
    "Moulay Bouazza",
    "Moulay Idriss Zerhoun",
    "Moussaoua",
    "N'Zalat Bni Amar",
    "Ouaoumana",
    "Oued Ifrane",
    "Sabaa Aiyoun",
    "Sebt Jahjouh",
    "Sidi Addi",
    "Tichoute",
    "Tighassaline",
    "Tighza",
    "Timahdite",
    "Tinejdad",
    "Tizguite",
    "Toulal",
    "Tounfite",
    "Zaouia d'Ifrane",
    "Zaïda",
    "Ahfir",
    "Aklim",
    "Al Aroui",
    "Aïn Bni Mathar",
    "Aïn Erreggada",
    "Ben Taïeb",
    "Berkane",
    "Bni Ansar",
    "Bni Chiker",
    "Bni Drar",
    "Bni Tadjite",
    "Bouanane",
    "Bouarfa",
    "Bouhdila",
    "Dar El Kebdani",
    "Debdou",
    "Douar Kannine",
    "Driouch",
    "El Aïoun Sidi Mellouk",
    "Farkhana",
    "Figuig",
    "Ihddaden",
    "Jaâdar",
    "Jerada",
    "Kariat Arekmane",
    "Kassita",
    "Kerouna",
    "Laâtamna",
    "Madagh",
    "Midar",
    "Nador",
    "Naima",
    "Oued Heimer",
    "Oujda",
    "Ras El Ma",
    "Saïdia",
    "Selouane",
    "Sidi Boubker",
    "Sidi Slimane Echcharaa",
    "Talsint",
    "Taourirt",
    "Tendrara",
    "Tiztoutine",
    "Touima",
    "Touissit",
    "Zaïo",
    "Zeghanghane",
    "Rabat",
    "Salé",
    "Ain El Aouda",
    "Harhoura",
    "Khémisset",
    "Oulmès",
    "Rommani",
    "Sidi Allal El Bahraoui",
    "Sidi Bouknadel",
    "Skhirate",
    "Tamesna",
    "Témara",
    "Tiddas",
    "Tiflet",
    "Touarga",
    "Agadir",
    "Agdz",
    "Agni Izimmer",
    "Aït Melloul",
    "Alnif",
    "Anzi",
    "Aoulouz",
    "Aourir",
    "Arazane",
    "Aït Baha",
    "Aït Iaâza",
    "Aït Yalla",
    "Ben Sergao",
    "Biougra",
    "Boumalne-Dadès",
    "Dcheira El Jihadia",
    "Drargua",
    "El Guerdane",
    "Harte Lyamine",
    "Ida Ougnidif",
    "Ifri",
    "Igdamen",
    "Ighil n'Oumgoun",
    "Imassine",
    "Inezgane",
    "Irherm",
    "Kelaat-M'Gouna",
    "Lakhsas",
    "Lakhsass",
    "Lqliâa",
    "M'semrir",
    "Massa (Maroc)",
    "Megousse",
    "Ouarzazate",
    "Oulad Berhil",
    "Oulad Teïma",
    "Sarghine",
    "Sidi Ifni",
    "Skoura",
    "Tabounte",
    "Tafraout",
    "Taghzout",
    "Tagzen",
    "Taliouine",
    "Tamegroute",
    "Tamraght",
    "Tanoumrite Nkob Zagora",
    "Taourirt ait zaghar",
    "Taroudannt",
    "Temsia",
    "Tifnit",
    "Tisgdal",
    "Tiznit",
    "Toundoute",
    "Zagora",
    "Afourar",
    "Aghbala",
    "Azilal",
    "Aït Majden",
    "Beni Ayat",
    "Béni Mellal",
    "Bin elouidane",
    "Bradia",
    "Bzou",
    "Dar Oulad Zidouh",
    "Demnate",
    "Dra'a",
    "El Ksiba",
    "Foum Jamaa",
    "Fquih Ben Salah",
    "Kasba Tadla",
    "Ouaouizeght",
    "Oulad Ayad",
    "Oulad M'Barek",
    "Oulad Yaich",
    "Sidi Jaber",
    "Souk Sebt Oulad Nemma",
    "Zaouïat Cheikh",
    "Tanger‎",
    "Tétouan‎",
    "Akchour",
    "Assilah",
    "Bab Berred",
    "Bab Taza",
    "Brikcha",
    "Chefchaouen",
    "Dar Bni Karrich",
    "Dar Chaoui",
    "Fnideq",
    "Gueznaia",
    "Jebha",
    "Karia",
    "Khémis Sahel",
    "Ksar El Kébir",
    "Larache",
    "M'diq",
    "Martil",
    "Moqrisset",
    "Oued Laou",
    "Oued Rmel",
    "Ouazzane",
    "Point Cires",
    "Sidi Lyamani",
    "Sidi Mohamed ben Abdallah el-Raisuni",
    "Zinat",
    "Ajdir‎",
    "Aknoul‎",
    "Al Hoceïma‎",
    "Aït Hichem‎",
    "Bni Bouayach‎",
    "Bni Hadifa‎",
    "Ghafsai‎",
    "Guercif‎",
    "Imzouren‎",
    "Inahnahen‎",
    "Issaguen (Ketama)‎",
    "Karia (El Jadida)‎",
    "Karia Ba Mohamed‎",
    "Oued Amlil‎",
    "Oulad Zbair‎",
    "Tahla‎",
    "Tala Tazegwaght‎",
    "Tamassint‎",
    "Taounate‎",
    "Targuist‎",
    "Taza‎",
    "Taïnaste‎",
    "Thar Es-Souk‎",
    "Tissa‎",
    "Tizi Ouasli‎",
    "Laayoune‎",
    "El Marsa‎",
    "Tarfaya‎",
    "Boujdour‎",
    "Awsard",
    "Oued-Eddahab",
    "Stehat",
    "Aït Attab"
  ];


  List<dynamic> places = [];
  List<String> places_sug = [];

  getPlaces() async
  {
    Dio dio = new Dio();

    if(_city_controller.text.isEmpty)
      ConnectionCheck.showAlert(context, "Enter the city name first");
    else if (!list.contains(_city_controller.text))
      ConnectionCheck.showAlert(context, "Enter the correct city name");
    else {
      dio.get("${AppConfig.ip}/api/places", queryParameters: {
        "city": _city_controller.text
      }).then((data){
        if(data.statusCode == 200)
        {
          places_sug.clear();
          setState(() {
            places = data.data;
            places.forEach((it){
              places_sug.add(it["name"]);
            });
            print(places_sug);
          });
        }
        else
          ConnectionCheck.checkConnection(context);
      });
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
                   "${AppConfig.ip}/api/place-get", queryParameters: {
                 "serieID": data
               });

              if(res.statusCode == 200)
              {

                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => new DashScreen(data: res.data[0],)));
              }
              else ConnectionCheck.showAlert(context, "QR invalide");
          }
        });
      });

    }
    else
      ConnectionCheck.showAlert(context, "Camera error");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 60),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 10),
                  width: 50,
                  child: Container(
                    child: IconButton(icon: Icon(Icons.menu, size: 40,), color: Colors.grey[800], onPressed: (){
                      widget.toggle();
                    }, alignment: Alignment.center),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo_name.png")
                        )
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 50,
                ),
              ],
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Form(
                    key: key,
                    child:  ScrollConfiguration(
                      behavior: ScrollBehaviorCos(),
                      child: ListView(
                        children: <Widget>[
                          Column(
                            children: <Widget>[

                              Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child: SimpleAutoCompleteTextField(
                                      key: key1,
                                      decoration: new InputDecoration(
                                          hintText: "Enter the city",
                                          labelStyle: new TextStyle(color: const Color(0xFF424242)),
                                          focusedBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Color(0xffec407a)
                                              )
                                          ),
                                          enabledBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.blue
                                              )
                                          )
                                      ),
                                      controller: _city_controller,
                                      suggestions: list,
                                      textChanged: (text) => currentText = text,
                                      clearOnSubmit: false,
                                      textSubmitted: (text) => setState(() {
                                        if (text != "") {
                                          currentText = text;
                                        }
                                      }),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: SimpleAutoCompleteTextField(
                                              key: key2,
                                              decoration: new InputDecoration(
                                                  hintText: "Enter the place",
                                                  labelStyle: new TextStyle(color: const Color(0xFF424242)),
                                                  focusedBorder: new UnderlineInputBorder(
                                                      borderSide: new BorderSide(
                                                          color: Color(0xffec407a)
                                                      )
                                                  ),
                                                  enabledBorder: new UnderlineInputBorder(
                                                      borderSide: new BorderSide(
                                                          color: Colors.blue
                                                      )
                                                  )
                                              ),
                                              controller: _nom_controller,
                                              suggestions: places_sug,
                                              textChanged: (text) => currentName = text,
                                              clearOnSubmit: false,
                                              onFocusChanged: (b){
                                                setState(() {
                                                  if(b)
                                                    getPlaces();
                                                  focus = b;
                                                });
                                              },
                                              textSubmitted: (text) => setState(() {
                                                if (text != "") {
                                                  currentName = text;
                                                }
                                              }),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: IconButton(icon: Icon(Icons.my_location), color: focus? Color(0xffec407a) : Colors.blue, onPressed: onLocationPress, alignment: Alignment.center),
                                          ),
                                        ],
                                      )
                                  ),

                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 50, bottom: 50, left: 60, right: 60),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child: Divider(color: Colors.black,)),
                                    Container(
                                      padding: EdgeInsets.only(left: 15, right: 15),
                                      child: Text("Or by", style: TextStyle(),),
                                    ),
                                    Expanded(child: Divider(color: Colors.black,)),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
//                                      margin: EdgeInsets.only(right: 20),
                                    child: Column(
                                      children: <Widget>[
                                        FlatButton(
                                          shape: new CircleBorder(),
                                          onPressed: ()async {
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              List<String> his = new List();
                                              if(prefs.containsKey("historyplace"))
                                              {
                                                his = prefs.getStringList("historyplace");
                                                if (await ConnectionCheck.checkConnection(context) == 1) {
                                                  Dio().post("${AppConfig.ip}/api/place-list", data: {
                                                    "serieID": his
                                                  }).then((data) {
                                                    if (data.statusCode == 200) {
                                                      Navigator.of(context).push(new MaterialPageRoute(
                                                          builder: (context) => new HistoryPlaceScreen(data: data.data, his: his,)));
                                                    }
                                                  });
                                                }
                                              }else
                                                Toast.show("No history", context, textColor: Colors.black, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM, backgroundColor: Colors.amber);
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle
                                            ),
                                            child: Icon(Icons.history, color: Colors.white,),
                                          ),),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text("History"),
                                        )
                                      ],
                                    )
                                  ),
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        FlatButton(
                                          shape: new CircleBorder(),
                                          onPressed: scanQr,
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle
                                            ),
                                            child: Icon(Icons.center_focus_weak, color: Colors.white,),
                                          ),),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text("QR"),
                                        )
                                      ],
                                    )
                                  )
                                ],
                              )

                            ],
                          ),
                        ],
                      ),
                    )
                  )
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
                          onPressed: onSearchPress,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          child: Container(
                              height: 25,
                              alignment: Alignment.center,
                              width: 150,
                              child: Text("Search", style: TextStyle(
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
      ),
    );
  }

}



class ScrollBehaviorCos extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}


class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {


  getNearby()
  async {
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) => new NearbyScreen()));
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[

          Container(
              margin: EdgeInsets.only(top: 100),
              child:Row(
                children: <Widget>[

                  Expanded(child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png")
                        )
                    ),
                  ),),

                  Expanded(child: Container()),
                  Expanded(child: Container())
                ],
              ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Divider(),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child:  FlatButton(
                        onPressed: getNearby,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.map),
                            Container(
                              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                              child: Text("Near by", style: TextStyle(fontSize: 18),),
                            ),
                            Expanded(
                              child: Container(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child:  FlatButton(
                        onPressed: () {

                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.settings),
                            Container(
                              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                              child: Text("Settings", style: TextStyle(fontSize: 18),),
                            ),
                            Expanded(
                              child: Container(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider()
                  ],
                ),
              ),
            )
          )
        ],
      )
    );
  }
}