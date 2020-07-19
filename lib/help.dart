import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: HexColor("#55965e"),
            ),
            onPressed: () =>
                Navigator.of(context).pop()
            ,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50,),
                  Center(
                    child: Container(
                      height: 50,
                      width: 80,
                      child: Image.asset('assets/Itda_black.png'),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: Text(
                      "자기주도적으로 마음을 다스리고 목표, 식사를\n"+
                          "계획하여 가정과 학교를 잇다",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                      width: 320,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  Icons.restaurant,
                                  size: 40,
                                  color: Colors.black
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30,10,0,0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "식사를 잇다",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "우리 학교 식단을 보고 "
                                        "내가 먹고 싶은 메뉴를 계획\n하여"
                                        "친구, 선생님, 부모님께 보여줄 수 있어요",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0,0,10,0),
                    width: 320,
                    child: Divider(thickness: 1),
                  ),
                  Container(
                      width: 320,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  Icons.favorite,
                                  size: 40,
                                  color: Colors.black
                              )
                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(30,10,0,0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "마음을 잇다",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "시, 이야기, 노래를 통해"
                                        "나의 마음을 다스리고\n"
                                        "상대방을 이해하기 위해 노력해 보아요",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0,0,10,0),
                    width: 320,
                    child: Divider(thickness: 1),
                  ),
                  Container(
                      width: 320,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  Icons.description,
                                  size: 40,
                                  color: Colors.black
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30,10,0,0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "목표를 잇다",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "내 목표를 정하고 "
                                        "친구들과 이야기하면서\n"
                                        "실천 의지를 높여요",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
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