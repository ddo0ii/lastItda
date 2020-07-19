import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itda/help.dart';
import 'package:itda/readSong.dart';
import 'package:itda/writeSong.dart';

class ConnectSong extends StatefulWidget {
  @override
  _ConnectSongState createState() => _ConnectSongState();
}

class _ConnectSongState extends State<ConnectSong> {
  String songKey="";
  Firestore _firestore = Firestore.instance;
  FirebaseUser user ;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  int point = -1;
  dynamic data;

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

  Future<String> songSettingDocument () async {
    DocumentReference songDocumentReference = await Firestore.instance.collection('songingList').add({});
    print(songDocumentReference.documentID);
    if(this.mounted) {
      setState(() {
        songKey = songDocumentReference.documentID;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => WriteSong(songKey: songKey)));
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 50.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              width: 200,
              height: 40,
              decoration: BoxDecoration(
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
                    width: 20.0,
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
            _slist(),
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
                    child: GestureDetector(
                      child: _wPBuildConnectItem('assets/itda_orange.png', '글쓰기'),
                      onTap: () => {
                        songSettingDocument(),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
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
  Widget _slist () {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('songList').snapshots(),
          builder: (context, snapshot) {
            //if (!snapshot.hasData) return LinearProgressIndicator();
            final items = snapshot.data.documents;

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/user.png'),
                      backgroundColor: Colors.white,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(item['nickname'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            //color: Colors.black,
                          ),
                        ),
                        Container(width: 10.0,),
                        Text(item['school'],
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(item['ssubject'],),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReadSong(songKey: item['songKey'],))),
                    },
                    //selected: true,
                  ),
                );
              },
            );
          }
      ),
    );
  }
}

class SRecord{
  final String nickname;
  final String school;
  final String clas;
  final String grade;
  final String email;
  final String ssubject;
  final String scontent;
  final String srecord;
  final String sindexing;

  SRecord.fromMap(Map<String, dynamic> map)
      : assert(map['nickname'] != null),
        assert(map['schoolname'] != null),
        assert(map['class'] != null),
        assert(map['grade'] != null),
        assert(map['email'] != null),
        assert(map['ssubject'] != null),
        assert(map['scontent'] != null),
        assert(map['srecord'] != null),
        assert(map['sindexing'] != null),

        nickname = map['nickname'],
        school = map['schoolname'],
        clas = map['class'],
        email =map['email'],
        grade = map['grade'],
        ssubject =map['ssubject'],
        scontent =map['scontent'],
        srecord =map['srecord'],
        sindexing =map['sindexing'];

  SRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

}