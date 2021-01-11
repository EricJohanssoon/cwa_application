import 'dart:io';

import 'package:cwa_application/registerPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'loginPage.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool flareFaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          flareFaded = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30.0),
      borderOnForeground: false,
      color: Colors.black,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          color: Colors.black,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFF6740FB), width: 2),
              borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            Navigator.push(
                context,
                !Platform.isIOS
                    ? PageTransition(
                        duration: Duration(milliseconds: 420),
                        type: PageTransitionType.fade,
                        child: LoginPage(),
                      )
                    : CupertinoPageRoute(builder: (context) => LoginPage()));
          },
          child: RichText(
            text: TextSpan(
              text: 'Login',
              style: TextStyle(
                fontFamily: 'Ginto',
                color: Color(0xFFDCDCDC),
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );

    final registerButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          color: Colors.black,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFF6740FB), width: 2),
              borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            Navigator.push(
                context,
                !Platform.isIOS
                    ? PageTransition(
                        duration: Duration(milliseconds: 420),
                        type: PageTransitionType.fade,
                        child: RegisterPage(),
                      )
                    : CupertinoPageRoute(builder: (context) => RegisterPage()));
          },
          child: RichText(
            text: TextSpan(
              text: 'Register',
              style: TextStyle(
                fontFamily: 'Ginto',
                color: Color(0xFFDCDCDC),
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(children: <Widget>[
          Positioned.fill(
            bottom: 0,
            child: AnimatedOpacity(
              opacity: flareFaded ? 1.0 : 0.0,
              duration: Duration(milliseconds: 3000),
              child: FlareActor(
                "assets/CwaBackground2.flr",
                animation: "splash",
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            // color: Colors.black54,
            child: Padding(
              padding: EdgeInsets.only(
                  top: height * 0.04, left: width / 12, right: width / 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 800),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 20.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.18, bottom: height * 0.06),
                        child: Hero(
                          tag: 'logo',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text('CWA',
                                style: TextStyle(
                                    fontFamily: 'Ginto',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6740FB),
                                    fontSize: 48)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.04),
                        child: loginButton,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.04),
                        child: registerButton,
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
