import 'package:flutter/material.dart';
import 'signup.dart';
import 'profile.dart';
import 'home.dart';
import 'goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final databaseReference = Firestore.instance;

String _email;
String _password;
final FirebaseAuth _auth = FirebaseAuth.instance;


GlobalKey<FormState> _loginKey = GlobalKey<FormState>(debugLabel: '_loginkey');
final form = _loginKey.currentState;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();


  void validateAndSubmit() async {
    if (form.validate()) {
      try {
        form.save();
        FirebaseUser user = (await _auth.signInWithEmailAndPassword(
            email: _email, password: _password)).user;
        print('Signed In: ${user.uid}');
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print('Error: $e');
      }
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: screenHeight*0.2,),
          Center(
              child: Container(
                height: 120,
                width: 120,
                child: Image.asset('assets/Font.png'),
              )
          ),
          SizedBox(height: screenHeight*0.1,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),

                children: <Widget>[
                  SizedBox(height: screenHeight*0.1,),
                  Form(
                    key: _loginKey,
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Row(
                            children: [
                              Container(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(10,0,0,0),
                                    border: InputBorder.none,
                                    labelText: '아이디',
                                    filled: true,
                                    fillColor: HexColor("#e9f4eb"),
                                  ),
                                  validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                                  onSaved: (value) => _email = value,
                                ),
                                width: screenWidth*0.7,
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: Container(
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(10,0,0,0),
                                border: InputBorder.none,
                                labelText: '비밀번호',
                                filled: true,
                                fillColor: HexColor("#e9f4eb"),
                              ),
                              validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                              onSaved: (value) => _password = value,
                              obscureText: true,
                            ),
                            width: screenWidth*0.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 45,),
                  Center(
                    child: Container(
                      width: screenWidth*0.7,
                      child: Row(
                        children: [
                          RaisedButton(
                            padding: EdgeInsets.fromLTRB(screenWidth*0.1,screenHeight*0.02,screenWidth*0.1,screenHeight*0.02),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: HexColor("#53975c")),
                            ),
                            child: Text(
                              '회원가입',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignupPage()));
                            },
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RaisedButton(
                                  padding: EdgeInsets.fromLTRB(screenWidth*0.11,screenHeight*0.02,screenWidth*0.11,screenHeight*0.02),
                                  color: HexColor("#55965e"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    '로그인',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    validateAndSubmit();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.icon,
        this.hint,
        this.obsecure = false,
        this.validator,
        this.onSaved});
  final FormFieldSetter<String> onSaved;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        autofocus: true,
        obscureText: obsecure,
        style: TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 30, right: 10),
            )),
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