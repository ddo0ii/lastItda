//https://fluttercentral.com/Articles/Post/1199/Flutter_DatePicker_Example => datepicker
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:itda/help.dart';
import 'package:itda/schoolMeal.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';

class SchoolMealEdit extends StatefulWidget {
  @override
  _SchoolMealEditState createState() => _SchoolMealEditState();
}

class _SchoolMealEditState extends State<SchoolMealEdit> {
  var today_date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final _formKey = GlobalKey<FormState>();

  Firestore _firestore = Firestore.instance;
  FirebaseUser user;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  int point = -1;
  dynamic data = "데이터";

  File _image1, _image2 = null;
  String pic1 = "식단";
  String pic2 = "알레르기정보";
  String pic1n = "식단";
  String pic2n = "알레르기정보";
  String schoolName = "학교이름";

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _schoolImgUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _ImageURL1 = "url";
  String _ImageURL2 = "url";

  var finaldate;

  void callDatePicker() async {
    var order = await getDate();
    var datehwa = DateFormat('yyyy-MM-dd').format(order);
    setState(() {
      finaldate = datehwa;
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

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

  @override
  void initState() {
    super.initState();
    getUser();
    _prepareService();
  }

  void _prepareService() async {
    _schoolImgUser = await _firebaseAuth.currentUser();
  }

  void setTapping()async{
    await Firestore.instance.collection('schoolMealList').document(school)
        .setData({'email':email, 'nickname':nickname, 'school':school, 'clas':clas, 'grade':grade,
      'pic1' : _ImageURL1, 'pic2' : _ImageURL2,
      'pic1n' : pic1n, 'pic2n' : pic2n});
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
          backgroundColor: HexColor("#e9f4eb"),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "식사를 ",
                style: TextStyle(
                  fontSize: screenWidth*0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                width: 28,
                child: Image.asset("assets/Itda_black.png"),
              ),
            ],
          )
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child:
                  Column(
                    children: <Widget>[
                      //윗줄 사진
                      Container(
                        child: Image(
                          image: AssetImage('assets/oneline.png'),
                          height: screenWidth*0.12,
                        ),
                      ),
                      //학교이미지, 이름, 날짜, 식단정보
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //학교이미지
                                  Container(
                                    width: screenWidth*0.15,
                                    child: Image.asset('assets/school_green.png'),
                                    //color: Colors.white,
                                  ),
                                  Container( height: screenWidth*0.03,),
                                  //학교이름
                                  Container(
                                    child: Text(
                                      school,
                                      style: TextStyle(
                                        color: Color(0xff53975c),
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
                            Container(height: screenWidth*0.03,),
                            //바
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    width: screenWidth*0.35,
                                    child: Divider(thickness: 1),
                                  ),
                                  Container(
                                    child: Icon(
                                      Icons.star,
                                      color: Color(0xfffbb359),
                                      size: screenWidth*0.07,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    width: screenWidth*0.35,
                                    child: Divider(thickness: 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: screenWidth*0.03,),
                      //날짜
                      InkWell(
                        child: Container(
                          width: screenWidth*0.6,
                          height: screenWidth*0.1,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffb5c8bc),
                            ),
                            color: Colors.white,
                          ),
                          child: finaldate == null
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  "날짜를 선택해주세요",
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Arita-dotum-_OTF",
                                    fontStyle: FontStyle.normal,
                                    fontSize: screenWidth*0.04,
                                  ),
                                  textAlign: TextAlign.center
                              )
                            ],
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  "$finaldate",
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Arita-dotum-_OTF",
                                    fontStyle: FontStyle.normal,
                                    fontSize: screenWidth*0.04,
                                  ),
                                  textAlign: TextAlign.center
                              )
                            ],
                          ),
                        ),
                        onTap: callDatePicker,
                      ),
                      Container(height: screenWidth*0.02,),
                      //이미지 넣기
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        width: screenWidth*0.9,
                        height: screenWidth*0.7,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffb5c8bc),
                          ),
                          color: Colors.white,
                        ),
                        child: _smallImageItem(getGalleryImage1, _image1, pic1n),
                      ),
                      //알레르기 정보
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: screenWidth*0.03,
                            ),
                            Container(
                              width: screenWidth*0.4,
                              height: screenWidth*0.1,
                              decoration: BoxDecoration(
                                  color: const Color(0xfffbb359)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '알레르기 정보',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Arita-dotum-_OTF",
                                      fontStyle: FontStyle.normal,
                                      fontSize: screenWidth*0.04,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth*0.9,
                              height: screenWidth*0.5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xfffbb359)
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: _ssmallImageItem(getGalleryImage2, _image2, pic2n),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: screenWidth*0.03,),
                      //잇기버튼
                      Container(
                        width: screenWidth*0.8,
                        height: screenWidth*0.15,
                        decoration: BoxDecoration(
                          color: Color(0xfffff7ef),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0),
                          ),
                        ),
                        child: InkWell(
                          child: GestureDetector(
                            child: _wPBuildConnectItem('assets/itda_orange.png', '잇기(올리기)'),
                            onTap: () {
                              setTapping();
                              Navigator.pop(context, MaterialPageRoute(builder: (context) => SchoolMeal()));
                            },
                          ),
                        ),
                      ),
                      Container(height: screenWidth*0.02,),
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
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: screenWidth*0.08,
            height: screenWidth*0.08,
            child: Image.asset(wPimgPath),
            //color: Colors.white,
          ),
          Container(
            height: screenWidth*0.004,
          ),
          Container(
            child: Text(
              wPlinkName,
              style: TextStyle(
                color: Color(0xfffbb359),
                fontWeight: FontWeight.w700,
                fontFamily: "Arita-dotum-_OTF",
                fontStyle: FontStyle.normal,
                fontSize: screenWidth*0.025,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getGalleryImage1() async {
    File image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    //var image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image1 == null) return;
    setState(() {
      _image1 = image1;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("schoolFoodImg/${_schoolImgUser.uid}_1_1");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image1);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL1 = downloadURL;
    });
  }

  void getGalleryImage2() async {
    File image2 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    //var image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image2 == null) return;
    setState(() {
      _image2 = image2;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("schoolFoodImg/${_schoolImgUser.uid}_1_2");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image2);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL2 = downloadURL;
    });
  }

  Widget _smallImageItem(Function gettingImg, File sImgPath, String sImgName){
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: gettingImg,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Container(
                    width: screenWidth*0.8,
                    height: screenWidth*0.6,
                    child: sImgPath == null ?
                    Container(child: Image.asset('assets/add_photo.png'),)
                        : Image.file(sImgPath),
                    decoration: BoxDecoration(
                      color: Color(0xffd1dad5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ssmallImageItem(Function gettingImg, File sImgPath, String sImgName){
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: gettingImg,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Container(
                    width: screenWidth*0.8,
                    height: screenWidth*0.4,
                    child: sImgPath == null ?
                    Container(child: Image.asset('assets/add_photo.png'),)
                        : Image.file(sImgPath),
                    decoration: BoxDecoration(
                      color: Color(0xffd1dad5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _uploadingDayMeal(){
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Column(
        children: <Widget>[
          //날짜
          InkWell(
            child: Container(
              width: screenWidth*0.6,
              height: screenWidth*0.1,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffb5c8bc),
                ),
                color: Colors.white,
              ),
              child: finaldate == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      "날짜를 선택해주세요",
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Arita-dotum-_OTF",
                        fontStyle: FontStyle.normal,
                        fontSize: screenWidth*0.04,
                      ),
                      textAlign: TextAlign.center
                  )
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      "$finaldate",
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Arita-dotum-_OTF",
                        fontStyle: FontStyle.normal,
                        fontSize: screenWidth*0.04,
                      ),
                      textAlign: TextAlign.center
                  )
                ],
              ),
            ),
            onTap: callDatePicker,
          ),
          Container(height: screenWidth*0.02,),
          //이미지 넣기
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            width: screenWidth*0.9,
            height: screenWidth*0.7,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffb5c8bc),
              ),
              color: Colors.white,
            ),
            child: _smallImageItem(getGalleryImage1, _image1, pic1n),
          ),
          //알레르기 정보
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: screenWidth*0.03,
                ),
                Container(
                  width: screenWidth*0.4,
                  height: screenWidth*0.1,
                  decoration: BoxDecoration(
                      color: const Color(0xfffbb359)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '알레르기 정보',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Arita-dotum-_OTF",
                          fontStyle: FontStyle.normal,
                          fontSize: screenWidth*0.04,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth*0.9,
                  height: screenWidth*0.5,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xfffbb359)
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: _ssmallImageItem(getGalleryImage2, _image2, pic2n),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(height: screenWidth*0.03,),
        ],
      ),
    );
  }
}