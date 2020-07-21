import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medcorder_audio/medcorder_audio.dart';
import 'package:itda/help.dart';
import 'package:itda/connectStory.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:itda/help.dart';

class ReadStory extends StatefulWidget {
  String storyKey="키";
  final LocalFileSystem localFileSystem;
  ReadStory({Key key,@required this.storyKey, this.localFileSystem}) : super(key: key);
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


  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

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

  @override
  void initState() {
    super.initState();
    getUser();
    getStory();
    _storyPrepareService();

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
                SizedBox(height: screenWidth*0.15,),
                Container(
                  width: screenWidth*0.6,
                  height: screenWidth*0.15,
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
                        width: screenWidth*0.065,
                        child: Image.asset('assets/ink.png'),
                        //color: Colors.white,
                      ),
                      Container(width: screenWidth*0.05),
                      Container(
                        child: Text(
                          '이야기로 마음을 잇다',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Arita-dotum-_OTF",
                            fontStyle: FontStyle.normal,
                            fontSize: screenWidth*0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: screenWidth*0.2,
                  width: screenWidth*1.0,
                  decoration: BoxDecoration(
                      color: const Color(0xffe9f4eb)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: screenWidth*0.04),
                            Container(
                              child: InkWell(
                                onTap: onPlayAudio,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: screenWidth*0.07,
                                        child: Image.asset('assets/listen.png'),
                                        //color: Colors.white,
                                      ),
                                      Container(
                                        height: screenWidth*0.02,
                                      ),
                                      Container(
                                        child: Text(
                                          '녹음 듣기',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Arita-dotum-_OTF",
                                            fontStyle: FontStyle.normal,
                                            fontSize: screenWidth*0.03,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth*0.35,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(school + '  ' + grade + '학년 ' + clas + '반',
                                  style: TextStyle(
                                    fontSize: screenWidth*0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: screenWidth*0.02,),
                                Text(nickname + ' 작성',
                                  style: TextStyle(
                                    fontSize: screenWidth*0.03,
                                    //fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //width: 200.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: screenWidth*1.0,
                  height: screenWidth*1.2,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffe9f4eb),
                        width: 1.0,
                      ),
                      color: const Color(0xffffffff)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: screenWidth*0.02,),
                      Text('제목',
                        style: TextStyle(
                          fontSize: screenWidth*0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenWidth*0.02,),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        width: screenWidth*1.0,
                        height: screenWidth*0.15,
                        decoration: BoxDecoration(
                            color: const Color(0x69e9f4eb)
                        ),
                        child: Text(ssubject),
                      ),
                      SizedBox(height: screenWidth*0.02,),
                      Text('나의 느낀점(다짐)',
                        style: TextStyle(
                          fontSize: screenWidth*0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenWidth*0.02,),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        width: screenWidth*1.0,
                        height: screenWidth*0.8,
                        decoration: BoxDecoration(
                            color: const Color(0x69e9f4eb)
                        ),
                        child: Text(scontent),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth*0.03,),
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
                        child: InkWell(
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
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: screenWidth*0.2,
      height: screenWidth*0.17,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: screenWidth*0.07,
            child: Image.asset(wPimgPath),
            //color: Colors.white,
          ),
          Container(
            height: screenWidth*0.02,
          ),
          Container(
            child: Text(
              wPlinkName,
              style: TextStyle(
                color: Color(0xfffbb359),
                fontWeight: FontWeight.w700,
                fontFamily: "Arita-dotum-_OTF",
                fontStyle: FontStyle.normal,
                fontSize: screenWidth*0.03,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(srecord, isLocal: true);
  }
}