import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'dart:typed_data' show Uint8List, ByteBuffer;
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PhotoHero extends StatefulWidget {

  String link;
  PhotoHero({@required this.link});

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
                tag: "image",
                child: PhotoView(
                  imageProvider: CachedNetworkImageProvider(widget.link),
                ),
              )
          ),
        )
    );
  }
}

class ArticleScreen extends StatefulWidget {

  var data;
  var id;

  ArticleScreen({Key key, this.data, this.id}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> with TickerProviderStateMixin  {

  TabController tabController;
  int pos;

  String _platformVersion = 'Unknown';
  @override
  void initState() {
    saveHistory();
    tabController = TabController(initialIndex: 0,length: 3, vsync: this);
    pos = 0;
    tabController.addListener((){
      setState(() {
        pos = tabController.index;
      });
    });
    top = 300;
    super.initState();
  }

  saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = new List();

    if(prefs.containsKey("history"))
      list = prefs.getStringList("history");

    if(!list.contains(widget.id))
    {
      list.add(widget.id);
      prefs.setStringList("history", list);
    }
  }

  var top;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(

                automaticallyImplyLeading: false,
                expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              top = constraints.biggest.height;
              return FlexibleSpaceBar(
                  centerTitle: true,
                  title:Container(
                    alignment: Alignment.bottomCenter,
                    child:  Text(widget.data["name"], style: TextStyle(
                        color: constraints.biggest.height <= 88? Colors.black : Colors.white
                    ),),
                  ),
                  background: Container(
                    child: Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute<void>(
                                builder: (BuildContext context)=> PhotoHero(link: widget.data["image"])
                            ));
                          },
                          child: Hero(tag: "image", child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                                    image: CachedNetworkImageProvider(widget.data["image"])
                                )
                            ),
                          ),),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 30, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(icon:Icon(Icons.arrow_back_ios, color: top <= 88 ? Colors.black: Colors.white,),
                                    onPressed:() => Navigator.pop(context),
                                  ),
                                  IconButton(icon: Icon(Icons.share, color: Colors.white, size: 25),alignment: Alignment.center, onPressed: () async {
                                    Share.share('check out my website https://example.com');
                                  }),
                                ],
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            )
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.only(bottom: 30),
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(70.0), // here the desired height
                child:TabBar(
                  tabs: [
                    Tab(child: Text("En")),
                    Tab(child: Text("Fr")),
                    Tab(child: Text("Ar")),
                  ],
                ),
              ),
              body: TabBarView(
//                        physics: NeverScrollableScrollPhysics(),
                children: [
                  ArticleInside(data: widget.data, pos: 0),
                  ArticleInside(data: widget.data, pos: 1),
                  ArticleInside(data: widget.data, pos: 2),
                ],
              ),
            ),
          ),
        )
      ),
//      body: Container(
//        child: Column(
//          children: <Widget>[
//            Container(
//              height: 300,
//              child: Stack(
//                children: <Widget>[
//                  Hero(tag: "image", child: Container(
//                    decoration: BoxDecoration(
//                        image: DecorationImage(
//                            fit: BoxFit.cover,
//                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
//                            image: CachedNetworkImageProvider(widget.data["image"])
//                        )
//                    ),
//                  ),),
//                  Column(
//                    children: <Widget>[
//                      Container(
//                        padding: EdgeInsets.only(top: 20),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.end,
//                          children: <Widget>[
//                            IconButton(icon: Icon(Icons.fullscreen, color: Colors.white, size: 30,), onPressed: (){
//                              Navigator.of(context).push(MaterialPageRoute<void>(
//                                  builder: (BuildContext context)=> PhotoHero(link: widget.data["image"])
//                              ));
//                            })
//                          ],
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              Text(widget.data["name"], style: TextStyle(
//                                  fontSize: 28,
//                                  color: Colors.white
//                              ),),
//                              Text(widget.data["place"], style: TextStyle(
//                                  fontSize: 18,
//                                  fontStyle: FontStyle.italic,
//                                  color: Colors.white
//                              ),)
//                            ],
//                          ),
//                        ),
//                      ),
//                      Padding(
//                        padding: EdgeInsets.only(bottom: 20),
//                        child: Row(
//                          children: <Widget>[
//                            Expanded(child: Container(), flex: 1,),
//                            Expanded(child: Container(
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                children: <Widget>[
//                                  GestureDetector(
//                                    onTap: (){},
//                                    child: Container(
//                                      width: 45,
//                                      height: 45,
//                                      decoration: BoxDecoration(
//                                        shape: BoxShape.circle,
//                                        color: Colors.white,
//                                        boxShadow: [
//                                          BoxShadow(color: Colors.black26, offset: Offset.zero, blurRadius: 2, spreadRadius: 0),
//                                        ],
//                                      ),
//                                      child: IconButton(icon: Icon(Icons.share, color: Colors.blue, size: 25),alignment: Alignment.center, onPressed: () async {
//                                        Share.share('check out my website https://example.com');
//                                      }),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ), flex: 2,),
//                            Expanded(child: Container(), flex: 1,),
//                          ],
//                        ),
//                      )
//                    ],
//                  )
//                ],
//              ),
//            ),
//
//            Column(
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(top: 10),
//                  height: MediaQuery.of(context).size.height - 300,
//                  child: DefaultTabController(
//                    length: 3,
//                    child: Scaffold(
//                      backgroundColor: Colors.white,
//                      appBar: PreferredSize(
//                          preferredSize: Size.fromHeight(70.0), // here the desired height
//                          child:TabBar(
//                            tabs: [
//                              Tab(child: Text("En")),
//                              Tab(child: Text("Fr")),
//                              Tab(child: Text("Ar")),
//                            ],
//                          ),
//                      ),
//                      body: TabBarView(
//                        children: [
//                          ArticleInside(data: widget.data, pos: 0),
//                          ArticleInside(data: widget.data, pos: 1),
//                          ArticleInside(data: widget.data, pos: 2),
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            )
//          ],
//        ),
//      )
    );
  }

}

typedef void OnError(Exception exception);



class ArticleInside extends StatefulWidget {

  var data;
  int pos;

  ArticleInside({Key key, this.data, this.pos}) : super(key: key);

  @override
  State<ArticleInside> createState() => _ArticleInsideState();
}

class _ArticleInsideState extends State<ArticleInside>  {


  Widget remoteUrl() {
    return  PlayerWidget(url: widget.data["audio"][widget.pos]["url"]);
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: Wrap(
          children: <Widget>[
            remoteUrl(),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
              child: Html(
                data: widget.data["description"][widget.pos]["text"],
              )
            )
          ],
        )
      ),
    );
  }

}



enum PlayerState { stopped, playing, paused }

class PlayerWidget extends StatefulWidget {
  final String url;
  final bool isLocal;
  final PlayerMode mode;

  PlayerWidget(
      {@required this.url,
        this.isLocal = false,
        this.mode = PlayerMode.MEDIA_PLAYER
      });

  @override
  State<StatefulWidget> createState() {
    return new _PlayerWidgetState(url, isLocal, mode);
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String url;
  bool isLocal;
  PlayerMode mode;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  _PlayerWidgetState(this.url, this.isLocal, this.mode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, offset: Offset.zero, blurRadius: 2, spreadRadius: 0),
                  ],
                ),
                child: IconButton(
                    alignment: Alignment.center,

                    onPressed: _isPlaying ? () => _pause() : null,
                    iconSize: 24,
                    icon: new Icon(Icons.pause),
                    color: Colors.cyan
                    ),
              ),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffec407a),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, offset: Offset.zero, blurRadius: 2, spreadRadius: 0),
                  ],
                ),
                child:  IconButton(
                    alignment: Alignment.center,
                    onPressed: _isPlaying ? null : () => _play(),
                    iconSize: 35,
                    icon: new Icon(Icons.play_arrow, color: _isPlaying? Color(0xffA52C55):  Colors.white,),
                ),
              ),

              Container(
                alignment: Alignment.center,
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, offset: Offset.zero, blurRadius: 2, spreadRadius: 0),
                  ],
                ),
                child:  IconButton(
                    alignment: Alignment.center,

                    onPressed: _isPlaying || _isPaused ? () => _stop() : null,
                    iconSize: 24,
                    icon: new Icon(Icons.stop),
                    color: Colors.cyan
                    ),
              )
            ],
          ),
          new Padding(
            padding: new EdgeInsets.all(12.0),
            child: PhysicalModel(
              color: Colors.transparent,
              borderRadius:  BorderRadius.circular(80.0),
              clipBehavior: Clip.antiAlias,
              child: LinearProgressIndicator(
                value: (_position != null &&
                    _duration != null &&
                    _position.inMilliseconds > 0 &&
                    _position.inMilliseconds < _duration.inMilliseconds)
                    ? _position.inMilliseconds / _duration.inMilliseconds
                    : 0.0,
                backgroundColor: Colors.cyan.withOpacity(0.2),
                valueColor: new AlwaysStoppedAnimation(Colors.cyan),
              ),
            )
          ),
          new Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              new Text(
                _position != null
                    ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                    : _duration != null ? _durationText : '',
                style: new TextStyle(fontSize: 15.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription =
        _audioPlayer.onDurationChanged.listen((duration) => setState(() {
          _duration = duration;
        }));

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
          _position = p;
        }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
          _onComplete();
          setState(() {
            _position = _duration;
          });
        });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
        _duration != null &&
        _position.inMilliseconds > 0 &&
        _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result =
    await _audioPlayer.play(url, isLocal: isLocal, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}
