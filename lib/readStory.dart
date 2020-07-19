import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medcorder_audio/medcorder_audio.dart';
import 'package:itda/help.dart';

class ReadStory extends StatefulWidget {
  String storyKey;
  ReadStory({Key key,@required this.storyKey}) : super(key: key);
  @override
  _ReadStoryState createState() => _ReadStoryState();
}

class _ReadStoryState extends State<ReadStory> {
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

  MedcorderAudio audioModule = new MedcorderAudio();
  bool canRecord = false;
  double recordPower = 0.0;
  double recordPosition = 0.0;
  bool isRecord = false;
  bool isPlay = false;
  double playPosition = 0.0;
  String file = "";


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

  String ssubject = "";
  String scontent = "";
  String srecord = "";
  String sindexing = "";
  String storyKey = "키값";

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _storyfireUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> getStory () async {
    _storyfireUser = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("storyList").document(widget.storyKey);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        ssubject = snapshot.data["ssubject"];
        scontent = snapshot.data["scontent"];
        srecord = snapshot.data["srecord"];
        sindexing = snapshot.data["sindexing"];
        storyKey = snapshot.data["storyKey"];
      });
    });
  }

  void _storyPrepareService() async {
    _storyfireUser = await _firebaseAuth.currentUser();
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

  Future _startStopPlay() async {
    if (isPlay) {
      await audioModule.stopPlay();
    } else {
      await audioModule.startPlay({
        "file": srecord,
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
  void initState() {
    super.initState();
    getUser();
    getStory();
    _storyPrepareService();

    audioModule.setCallBack((dynamic redata) {
      _onEvent(redata);
    });
    _initSettings();
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
        child: SingleChildScrollView(
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
                          '이야기로 마음을 잇다',
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
                  height: 70,
                  decoration: BoxDecoration(
                      color: const Color(0xffe9f4eb)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(width: 30.0,),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: InkWell(
                                child: Container(
                                  child: isPlay ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 35,
                                        height: 35,
                                        child: IconButton(
                                          icon: Icon(Icons.stop),
                                          color: Colors.white,
                                          iconSize: 35.0,
                                          onPressed: () {
                                            print('정지');
                                          },
                                        ),
                                        //color: Colors.white,
                                      ),
                                      Container(
                                        height: 10.0,
                                      ),
                                      Container(
                                        child: Text(
                                          '  멈추기',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Arita-dotum-_OTF",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10.0,
                                      ),
                                    ],
                                  )
                                      :
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 35,
                                        height: 35,
                                        child: IconButton(
                                          icon: Icon(Icons.play_arrow),
                                          color: Colors.white,
                                          iconSize: 35.0,
                                          onPressed: () {
                                            print('녹음듣기');
                                          },
                                        ),
                                        //color: Colors.white,
                                      ),
                                      Container(
                                        height: 10.0,
                                      ),
                                      Container(
                                        child: Text(
                                          '  녹음 듣기',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Arita-dotum-_OTF",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10.0,
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
                          ],
                        ),
                      ),
                      Container(width: 30.0,),
                      Text('playing: ' + playPosition.toString()),
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
                              child: Text(ssubject),
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
                              child: Text(scontent),
                            ),
                            SizedBox(height: 10.0,),
                            Text('녹음파일',
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
                              height: 45.0,
                              decoration: BoxDecoration(
                                  color: const Color(0x69e9f4eb)
                              ),
                              child: Text(srecord),
                            ),
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
                            topRight: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                        ),
                        child: GestureDetector(
                          child: _wPBuildConnectItem('assets/list.png','목록'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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