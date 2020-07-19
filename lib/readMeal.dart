//https://minwook-shin.github.io/flutter-use-image-picker/ -->imagepicker
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itda/help.dart';

class ReadMeal extends StatefulWidget {
  String mealKey;
  ReadMeal({Key key,@required this.mealKey}) : super(key: key);
  @override
  _ReadMealState createState() => _ReadMealState();
}

class _ReadMealState extends State<ReadMeal> {
  Firestore _firestore = Firestore.instance;
  FirebaseUser user;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  int point = -1;
  dynamic data;

  File _image1, _image2, _image3, _image4, _image5, _image6 = null;
  final _formKey = GlobalKey<FormState>();
  bool tansu = false;
  bool danback = false;
  bool jibang = false;
  bool vitamin = false;
  bool moogi = false;
  bool water = false;
  String pic1, pic2, pic3, pic4, pic5, pic6;
  String pic1n = "사진1";
  String pic2n = "사진2";
  String pic3n = "사진3";
  String pic4n = "사진4";
  String pic5n = "사진5";
  String pic6n = "사진6";
  static int mindex = 1;
  String mindexing = "$mindex";
  String mealKey="키값";

  Future<String> getUser () async {
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("loginInfo").document(user.email);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        email =snapshot.data["email"];
        nickname =snapshot.data["nickname"];
        school = snapshot.data["schoolname"];
        grade = snapshot.data["grade"];
        clas = snapshot.data["class"];
        point = snapshot.data["point"];
      });
    });
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _imgUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _ImageURL1 = "";
  String _ImageURL2 = "";
  String _ImageURL3 = "";
  String _ImageURL4 = "";
  String _ImageURL5 = "";
  String _ImageURL6 = "";

  Future<String> getMeal() async {
    _imgUser = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("mealList").document(widget.mealKey);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        _image1 = snapshot.data["_image1"];
        _image2 = snapshot.data["_image2"];
        _image3 = snapshot.data["_image3"];
        _image4 = snapshot.data["_image4"];
        _image5 = snapshot.data["_image5"];
        _image6 = snapshot.data["_image6"];
        tansu = snapshot.data["tansu"];
        danback = snapshot.data["danback"];
        jibang = snapshot.data["jibang"];
        vitamin = snapshot.data["vitamin"];
        moogi = snapshot.data["moogi"];
        water = snapshot.data["water"];
        pic1 = snapshot.data["pic1"];
        pic2 = snapshot.data["pic2"];
        pic3 = snapshot.data["pic3"];
        pic4 = snapshot.data["pic4"];
        pic5 = snapshot.data["pic5"];
        pic6 = snapshot.data["pic6"];
        pic1n = snapshot.data["pic1n"];
        pic2n = snapshot.data["pic2n"];
        pic3n = snapshot.data["pic3n"];
        pic4n = snapshot.data["pic4n"];
        pic5n = snapshot.data["pic5n"];
        pic6n = snapshot.data["pic6n"];
        mindexing = snapshot.data["mindexing"];
        mealKey = snapshot.data["mealKey"];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getMeal();
    _prepareService();
  }

  void _prepareService() async {
    _imgUser = await _firebaseAuth.currentUser();
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
              onPressed: (){
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
                "식사를 ",
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage('assets/oneline.png'),
                  height: 50.0,
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 45,
                            height: 45,
                            child: Image.asset('assets/rice_green.png'),
                            //color: Colors.white,
                          ),
                          Container(
                            height: 10.0,
                          ),
                          Container(
                            child: Text(
                              '우리들의 식단',
                              style: TextStyle(
                                color: Color(0xff53975c),
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
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                            width: 140,
                            child: Divider(thickness: 1),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Icon(
                              Icons.star,
                              color: Color(0xfffbb359),
                              size: 17,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            width: 140,
                            child: Divider(thickness: 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      width: 350.0,
                      height: 270.0,
                      decoration: BoxDecoration(
                        color: Color(0xfff2f2f2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _smallImageItem(pic1, pic1n),
                                _smallImageItem(pic2, pic2n),
                                _smallImageItem(pic3, pic3n),
                                _smallImageItem(pic4, pic4n),
                              ],
                            ),
                          ),
                          Container(
                            height: 10.0,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _bigImageItem(pic5, pic5n),
                                _bigImageItem(pic6, pic6n),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 20.0,
                          ),
                          Container(
                            width: 100.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: const Color(0xfffbb359)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '영양소 확인',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Arita-dotum-_OTF",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            width: 300.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xfffbb359)
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _nutrients(tansu, "탄수화물"),
                                    _nutrients(danback, "단백질"),
                                    _nutrients(jibang, "지방"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _nutrients(vitamin, "비타민"),
                                    _nutrients(moogi, "무기질"),
                                    _nutrients(water, "물"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 10.0,),
                    Container(
                      width: 300.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Color(0xfffff7ef),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                      ),
                      child: GestureDetector(
                        child: _wPBuildConnectItem('assets/itda_orange.png', '목록으로 돌아가기'),
                        onTap: () async{
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Container(height: 10.0,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _wPBuildConnectItem( String wPimgPath, String wPlinkName) {
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
  Widget _smallImageItem(String sImgPath, String sImgName){
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 80.0,
                width: (screenWidth-40.0)/4.0,
                child: sImgPath == null ?
                Container(child: Image.asset('assets/add_photo.png'),)
                    : Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    color: Color(0xffd1dad5),
                    image: DecorationImage(image: NetworkImage(sImgPath),),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xffd1dad5),
                ),
              ),
              Container(
                height: 30.0,
                width: (screenWidth-40.0)/4.0,
                child: Text(sImgName),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(width: 2.0,),
        ],
      ),
    );
  }
  Widget _bigImageItem(String bImgPath, String bImgName){
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 100.0,
                width: (screenWidth-80.0)/2.0,
                child: bImgPath == null ?
                Container(child: Image.asset('assets/add_photo.png'),)
                    : Container(
                  height: 100.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    color: Color(0xffd1dad5),
                    image: DecorationImage(image: NetworkImage(bImgPath),),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xffd1dad5),
                ),
              ),
              Container(
                height: 30.0,
                width: (screenWidth-80.0)/2.0,
                child: Text(bImgName),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(width: 2.0,),
        ],
      ),
    );
  }
  Widget _nutrients(bool nuVal, String nuName){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: nuVal,
          onChanged: null,
        ),
        Text(nuName,
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}