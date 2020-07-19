import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:itda/help.dart';
import 'package:itda/schoolMeal.dart';
import 'package:intl/intl.dart';

class SchoolMeal extends StatefulWidget {
  @override
  _SchoolMealState createState() => _SchoolMealState();
}

class _SchoolMealState extends State<SchoolMeal> {
  var today_date = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
                            child: Image.asset('assets/school_green.png'),
                            //color: Colors.white,
                          ),
                          Container(
                            height: 10.0,
                          ),
                          Container(
                            child: Text(
                              '죽장초등학교',
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
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text(
                          today_date,
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Arita-dotum-_OTF",
                            fontStyle: FontStyle.normal,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center
                      ),
                    ),
                    Container(
                      width: 300.0,
                      height: 220.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xffb5c8bc),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              '단호박카레라이스 // 2, 5, 6, 10,13, 16, 18 \n'
                                  '콩나물국(소량) // 5, 6, 13, 14, 16, 18\n'
                                  '돌나물오이무침 // 5, 6, 13, 14, 16, 18\n'
                                  '배추김치 // 9, 13\n'
                                  '우리밀찹쌀꽈배기 // 1, 2, 5, 6, 13\n'
                                  '과일샐러드 // 1, 2, 5, 13, 16',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Arita-dotum-_OTF",
                                fontStyle: FontStyle.normal,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            height: 20.0,
                          ),
                          Container(
                            child: Text(
                              '* 에너지 731.7 / 단백질 24.6 / 칼슘 248 / 철분 5.9',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Arita-dotum-_OTF",
                                fontStyle: FontStyle.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
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
                            '알레르기 정보',
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
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      width: 300.0,
                      height: 100.0,
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
                            child: Text(
                              '1.난류 2.우유 3.메밀 4.땅콩 5.대두 6.밀 7.고등어 8.게 9.새우 '
                                  '10.돼지고기 11.복숭아 12.토마토 13.아황산류 14.호두 15.닭고기 '
                                  '16.쇠고기 17.오징어 18.조개류(굴,전복,홍합, 포함)',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Arita-dotum-_OTF",
                                fontStyle: FontStyle.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}