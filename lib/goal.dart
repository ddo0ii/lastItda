import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itda/goal_edit.dart';
import 'goal_edit.dart';
import 'package:itda/goal_list.dart';
import 'goal_list.dart';


class GoalPage extends StatefulWidget{
  String email;
  GoalPage({Key key,@required this.email}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {

  String today =" ";
  String week = "";
  String year="";
  String nickname = "";
  String dream = "";
  FirebaseUser user ;
  bool _todayBool = false;
  bool _weekBool = false;
  bool _yearBool = false;

  Future<String> getUser () async {
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("loginInfo").document(widget.email);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      if(this.mounted) {
        setState(() {
          today = snapshot.data["today"];
          week = snapshot.data["week"];
          year = snapshot.data["year"];
          nickname = snapshot.data["nickname"];
          dream = snapshot.data["dream"];
          _todayBool = snapshot.data["todaycheck"];
          _weekBool = snapshot.data["weekcheck"];
          _yearBool = snapshot.data["yearcheck"];
        });
      }
    });

  }

  Future<void> todayUpdate(String today) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'today' : today,
    });
  }

  Future<void> weekUpdate(String week) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'week' : week,
    });
  }

  Future<void> yearUpdate(String year) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'year' : year,
    });
  }


  Future<void> _editChecker() async {
    final user = await FirebaseAuth.instance.currentUser();
    if(user.email == widget.email){
      return  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoalEditPage(email: widget.email)));
    }
    else
      return null;
  }

  @override
  void initState() {

    super.initState();
    getUser();
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    getUser();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppBar(
              backgroundColor: HexColor("#e9f4eb"),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: HexColor("#fbb359"),
                  ),
                  onPressed: (){
                    _editChecker();
                  },
                )
              ],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "목표를 ",
                    style: TextStyle(
                      fontSize: 18,
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
          Expanded(
            child: ListView(
              children: <Widget>[
                Text(
                  "친구들의 목표를 보며 응원의 댓글을 남기면\n 더 잘할 수 있어요",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0,0,10,0),
                      width: 150,
                      child: Divider(thickness: 1),
                    ),
                    Icon(
                      Icons.star,
                      color: HexColor("#fbb359"),
                      size: 15,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10,0,0,0),
                      width: 150,
                      child: Divider(thickness: 1),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Center(
                  child: Container(
                    width: queryData.size.width * 0.6,
                    height: queryData.size.width * 0.5,
                    child:  Image.asset(
                      'assets/tree.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            nickname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: HexColor("#53975c"),
                            ),
                          ),
                          Text(
                              "님의 꿈은"
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dream,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: HexColor("#fbb359"),
                            ),
                          ),
                          Text(
                              "입니다"
                          )
                        ],
                      ),

                    ],
                  ),
                ),
                Container(width: 10.0,),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  width: queryData.size.width*0.5,
                  height: queryData.size.height*0.35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0) //                 <--- border radius here
                      ),
                      border: Border.all(color: HexColor("#96fab259"))
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20,0,0,10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "오늘의 목표",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Theme(
                              data: ThemeData(unselectedWidgetColor: HexColor("#fab259")),
                              child: Checkbox(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                checkColor: Colors.white,
                                activeColor: HexColor("#fab259"),
                                value: _todayBool,
                                onChanged: null,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                width: queryData.size.width*0.85,
                                height: queryData.size.height*0.04,
                                decoration: BoxDecoration(
                                  color: HexColor("#fff7ef"),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 0,0,0),
                                    ),
                                    Text(
                                      today,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Text(
                              "이번 의 목표",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Theme(
                              data: ThemeData(unselectedWidgetColor: HexColor("#fab259")),
                              child: Checkbox(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  checkColor: Colors.white,
                                  activeColor: HexColor("#fab259"),
                                  value: _weekBool,
                                  onChanged: null
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                width: queryData.size.width*0.85,
                                height: queryData.size.height*0.04,
                                decoration: BoxDecoration(
                                  color: HexColor("#fff7ef"),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 0,0,0),
                                    ),
                                    Text(
                                      week,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Text(
                              "올해의 목표",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Theme(
                              data: ThemeData(unselectedWidgetColor: HexColor("#fab259")),
                              child: Checkbox(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                checkColor: Colors.white,
                                activeColor: HexColor("#fab259"),
                                value: _yearBool,
                                onChanged: null,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                width: queryData.size.width*0.85,
                                height: queryData.size.height*0.04,
                                decoration: BoxDecoration(
                                  color: HexColor("#fff7ef"),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 0,0,0),
                                    ),
                                    Text(
                                      year,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}