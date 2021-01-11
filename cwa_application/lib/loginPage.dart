import 'package:cwa_application/Bool.dart';
import 'package:cwa_application/http_service.dart';
import 'package:cwa_application/scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'navigation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  bool _loginErrorIsActivated = false;
  Bool hasPlayed = Bool(value: false);
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        color: Color(0xFFDCDCDC), fontFamily: 'Ginto', fontSize: 14.0);
    final emailField = TextField(
        obscureText: false,
        style: style,
        controller: _emailController,
        onChanged: (String notUsed) {
          if (this.mounted) {
            setState(() {
              _loginErrorIsActivated = false;
            });
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, -10.0),
          hintText: "Email",
          hintStyle: style,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: _loginErrorIsActivated
                      ? Color(0xFFFF4040)
                      : Color(0xFF6740FB),
                  width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: _loginErrorIsActivated
                      ? Color(0xFFFF4040)
                      : Color(0xFF6740FB),
                  width: 3.0)),
        ));
    final passwordField = TextField(
        obscureText: false,
        style: style,
        controller: _phoneNumberController,
        onChanged: (String notUsed) {
          if (this.mounted) {
            setState(() {
              _loginErrorIsActivated = false;
            });
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, -10.0),
          hintText: "Mobile number",
          hintStyle: style,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6740FB), width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6740FB), width: 3.0)),
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: _loginErrorIsActivated
                      ? Color(0xFFFF4040)
                      : Color(0xFF6740FB),
                  width: 2.0)),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: _loginErrorIsActivated
                      ? Color(0xFFFF4040)
                      : Color(0xFF6740FB),
                  width: 3.0)),
          errorText: _loginErrorIsActivated
              ? "email and phoneNumber does not match"
              : null,
        ));

    final loginButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF6740FB),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: !isloading
            ? () async {
                if (this.mounted) {
                  setState(() {
                    isloading = true;
                  });
                }
                HttpService httpService = HttpService();
                String loggedIn = await httpService.login(
                    _emailController.text, _phoneNumberController.text);
                if (loggedIn != null) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.pop(context, true);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Navigation(memberId: loggedIn)),
                        ModalRoute.withName('/'));
                  });
                } else {
                  if (this.mounted) {
                    setState(() {
                      _loginErrorIsActivated = true;
                      isloading = false;
                    });
                  }
                }
              }
            : null,
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
    );

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    top: height * 0.3,
                    bottom: height * 0.06),
                child: Hero(
                  tag: 'logo',
                  child: Material(
                      type: MaterialType.transparency,
                      child: Text('CWA',
                          style: TextStyle(
                              fontFamily: 'Ginto',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6740FB),
                              fontSize: 48))),
                )),
            Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 40.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          left: width / 12,
                          right: width / 12),
                      child: emailField),
                  Container(
                      height: height / 6,
                      padding: EdgeInsets.only(
                          top: height / 30,
                          left: width / 12,
                          right: width / 12),
                      child: passwordField),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: height * 0.02,
                    left: width / 12,
                    right: width / 12),
                child: ScaledAnimation(
                  child: !isloading
                      ? loginButton
                      : CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Color(0xFF6740FB))),
                  delay_milliseconds: 500,
                  hasPlayed: hasPlayed,
                  key: UniqueKey(),
                ))
          ],
        ),
      ),
    );
  }
}
