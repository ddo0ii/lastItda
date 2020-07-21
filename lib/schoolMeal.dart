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
                  height: screenWidth*0.12,
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
                            width: screenWidth*0.15,
                            child: Image.asset('assets/school_green.png'),
                            //color: Colors.white,
                          ),
                          Container(
                            height: screenWidth*0.025,
                          ),
                          Container(
                            child: Text(
                              '죽장초등학교',
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
                    Container(height: screenWidth*0.02,),
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
                    Container(height: screenWidth*0.02,),
                    Container(
                      child: Text(
                          today_date,
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Arita-dotum-_OTF",
                            fontStyle: FontStyle.normal,
                            fontSize: screenWidth*0.04,
                          ),
                          textAlign: TextAlign.center
                      ),
                    ),
                    Container(height: screenWidth*0.02,),
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
                                fontSize: screenWidth*0.042,
                              ),
                            ),
                          ),
                          Container(
                            height: screenWidth*0.03,
                          ),
                          Container(
                            child: Text(
                              '* 에너지 731.7 / 단백질 24.6 / 칼슘 248 / 철분 5.9',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Arita-dotum-_OTF",
                                fontStyle: FontStyle.normal,
                                fontSize: screenWidth*0.035,
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
                      height: screenWidth*0.3,
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
                            child: Text(
                              '1.난류 2.우유 3.메밀 4.땅콩 5.대두 6.밀 7.고등어 8.게 9.새우 10.돼지고기 11.복숭아 12.토마토 13.아황산류 14.호두 15.닭고기 16.쇠고기 17.오징어 18.조개류(굴,전복,홍합, 포함)',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Arita-dotum-_OTF",
                                fontStyle: FontStyle.normal,
                                fontSize: screenWidth*0.035,
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