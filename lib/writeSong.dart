import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medcorder_audio/medcorder_audio.dart';
import 'package:itda/help.dart';
import 'package:itda/connectSong.dart';

class WriteSong extends StatefulWidget {
  String songKey="키";
  WriteSong({Key key,@required this.songKey}) : super(key: key);
  @override
  _WriteSongState createState() => _WriteSongState();
}

class _WriteSongState extends State<WriteSong> {
  String ssubject="제목";
  String scontent="내용";
  String srecord = "녹음";
  static int sindex = 1;
  String sindexing = "$sindex";

  Firestore _firestore = Firestore.instance;
  FirebaseUser user;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  int point = -1;
  dynamic data;
  final _formKey = GlobalKey<FormState>();

  Future<String> getUser () async {
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("loginInfo").document(user.email);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        nickname =snapshot.data["nickname"];
        school = snapshot.data["schoolname"];
        grade = snapshot.data["grade"];
        clas = snapshot.data["class"];
        point = snapshot.data["point"];
      });
    });
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _songfireUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  MedcorderAudio audioModule = new MedcorderAudio();
  bool canRecord = false;
  double recordPower = 0.0;
  double recordPosition = 0.0;
  bool isRecord = false;
  bool isPlay = false;
  double playPosition = 0.0;
  String file = "";

  @override
  void initState() {
    super.initState();
    getUser();
    _songPrepareService();
    print('hello'+widget.songKey);

    audioModule.setCallBack((dynamic redata) {
      _onEvent(redata);
    });
    _initSettings();
  }

  void _songPrepareService() async {
    _songfireUser = await _firebaseAuth.currentUser();
  }

  void songSetTapping() async{
    await Firestore.instance.collection('songList').document(widget.songKey)
        .setData({
      'email':email, 'nickname':nickname, 'school':school, 'clas':clas, 'grade':grade,
      'ssubject':ssubject, 'scontent':scontent, 'srecord': file, 'sindexing':sindexing,
      'songKey':widget.songKey});
  }

  Future _initSettings() async {
    final String result = await audioModule.checkMicrophonePermissions();
    if (result == 'OK') {
      await audioModule.setAudioSettings();
      setState(() {
        canRecord = true;
      });
    }
    return;
  }

  Future _startRecord() async {
    try {
      DateTime time = new DateTime.now();
      setState(() {
        file = time.millisecondsSinceEpoch.toString();
      });
      final String result = await audioModule.startRecord(file);
      setState(() {
        isRecord = true;
      });
      print('startRecord: ' + result);
    } catch (e) {
      file = "";
      print('startRecord: fail');
    }
  }

  Future _stopRecord() async {
    try {
      final String result = await audioModule.stopRecord();
      print('stopRecord: ' + result);
      setState(() {
        isRecord = false;
      });
    } catch (e) {
      print('stopRecord: fail');
      setState(() {
        isRecord = false;
      });
    }
  }

  Future _startStopPlay() async {
    if (isPlay) {
      await audioModule.stopPlay();
    } else {
      await audioModule.startPlay({
        "file": file,
        "position": 0.0,
      });
    }
  }

  void _onEvent(dynamic event) {
    if (event['code'] == 'recording') {
      double power = event['peakPowerForChannel'];
      setState(() {
        recordPower = (60.0 - power.abs().floor()).abs();
        recordPosition = event['currentTime'];
      });
    }
    if (event['code'] == 'playing') {
      String url = event['url'];
      setState(() {
        playPosition = event['currentTime'];
        isPlay = true;
      });
    }
    if (event['code'] == 'audioPlayerDidFinishPlaying') {
      setState(() {
        playPosition = 0.0;
        isPlay = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xffe9f4eb),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.help,
                color: Color(0xfffbb359),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpPage()));
              },
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "마음을 ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                width: 28,
                child: Image.asset('assets/Itda_black.png'),
              ),
            ],
          )
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: canRecord
            ? SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 50.0,),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: Color(0xffb5c8bc),
                      offset: Offset(0,10),
                    )] ,
                    color: Color(0xff53975c),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 20,
                        height: 20,
                        child: Image.asset('assets/ink.png'),
                        //color: Colors.white,
                      ),
                      Container(
                        width:20.0,
                      ),
                      Container(
                        child: Text(
                          '노래로 마음을 잇다',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Arita-dotum-_OTF",
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                      color: const Color(0xffe9f4eb)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(width: 10.0,),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: InkWell(
                                child: Container(
                                  child: isRecord ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 25,
                                        height: 25,
                                        child: Image.asset('assets/stop.png'),
                                        //color: Colors.white,
                                      ),
                                      Container(
                                        height: 3.0,
                                      ),
                                      Container(
                                        child: Text(
                                          '녹음 끝내기',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Arita-dotum-_OTF",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                      :
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 25,
                                        height: 25,
                                        child: Image.asset('assets/record.png'),
                                        //color: Colors.white,
                                      ),
                                      Container(
                                        height: 3.0,
                                      ),
                                      Container(
                                        child: Text(
                                          '녹음 하기',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Arita-dotum-_OTF",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  if (isRecord) {
                                    _stopRecord();
                                  } else {
                                    _startRecord();
                                  }
                                },
                              ),
                            ),
                            Container(width: 10.0,),
                            new Text('recording: ' + recordPosition.toString()),
                          ],
                        ),
                        //width: 200.0,
                      ),
                      Container(height: 10.0,),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(width: 10.0,),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: InkWell(
                                child: Container(
                                  child: isPlay ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 25,
                                        height: 25,
                                        child: Image.asset('assets/stop.png'),
                                        //color: Colors.white,
                                      ),
                                      Container(
                                        height: 3.0,
                                      ),
                                      Container(
                                        child: Text(
                                          '멈추기',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Arita-dotum-_OTF",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                      :
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 25,
                                        height: 25,
                                        child: Image.asset('assets/listen.png'),
                                        //color: Colors.white,
                                      ),
                                      Container(
                                        height: 3.0,
                                      ),
                                      Container(
                                        child: Text(
                                          '녹음 듣기',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Arita-dotum-_OTF",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  if (!isRecord && file.length > 0) {
                                    _startStopPlay();
                                  }
                                },
                              ),
                            ),
                            Container(width: 10.0,),
                            new Text('playing: ' + playPosition.toString()),
                          ],
                        ),
                        //width: 200.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 430.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffe9f4eb),
                        width: 1.0,
                      ),
                      color: const Color(0xffffffff)
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('제목',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                              width: screenWidth - 45.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: const Color(0x69e9f4eb)
                              ),
                              child: TextFormField(
                                maxLines: 1,
                                onChanged: (text) => ssubject = text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '제목을 쓰세요';
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '제목을 쓰세요',
                                  //labelText: "Enter your username",
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Text('나의 느낀점(다짐)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                              width: screenWidth - 45.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                  color: const Color(0x69e9f4eb)
                              ),
                              child: TextFormField(
                                maxLines: 30,
                                onChanged: (text) => scontent = text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '느낀점을 쓰세요';
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '느낀점을 쓰세요',
                                  //labelText: "Enter your username",
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xfffff7ef),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0),
                          ),
                        ),
                        child: InkWell(
                          child: GestureDetector(
                            child: _wPBuildConnectItem('assets/itda_orange.png','잇기(올리기)'),
                            onTap: () {
                              songSetTapping();
                              Navigator.pop(context, MaterialPageRoute(builder: (context) => ConnectSong()));
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xfffff7ef),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                        ),
                        child: _wPBuildConnectItem('assets/hold.png','나만보기'),
                      ),
                      /*
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xfffff7ef),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                        ),
                        child: _wPBuildConnectItem('assets/list.png','목록'),
                      ),
                      * */
                    ],
                  ),
                ),
                Container(height: 10.0,),
              ],
            ),
          ),
        )
            : Text(
          '마이크 접근이 금지 되어있습니다. 설정에서 마이크 접근 허용을 해주세요!',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  Widget _recordingItem(String rimgPath, String rlinkName) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 25,
            height: 25,
            child: Image.asset(rimgPath),
            //color: Colors.white,
          ),
          Container(
            height: 3.0,
          ),
          Container(
            child: Text(
              rlinkName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontFamily: "Arita-dotum-_OTF",
                fontStyle: FontStyle.normal,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _wPBuildConnectItem(String wPimgPath, String wPlinkName) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: 80.0,
      height: 50.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 20,
            height: 20,
            child: Image.asset(wPimgPath),
            //color: Colors.white,
          ),
          Container(
            height: 3.0,
          ),
          Container(
            child: Text(
              wPlinkName,
              style: TextStyle(
                color: Color(0xfffbb359),
                fontWeight: FontWeight.w700,
                fontFamily: "Arita-dotum-_OTF",
                fontStyle: FontStyle.normal,
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}