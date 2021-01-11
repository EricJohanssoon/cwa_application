import 'package:cwa_application/Bool.dart';
import 'package:cwa_application/navigation.dart';
import 'package:cwa_application/scale_animation.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'http_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  bool _isMember = false;
  bool _isPartOfChalmers = false;
  bool _isPolicy = false;

  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final fullNameController = TextEditingController();
  final programmeAndYearOfAdmissionController = TextEditingController();

  bool _emailIsMissing = false;
  bool _phoneNumberIsMissing = false;
  bool _fullNameIsMissing = false;
  bool _programmeAndYearOfAdmissionIsMissing = false;
  bool _emailIsWrongFormat = false;
  bool _accountAlreadyExist = false;

  Bool hasPlayed = Bool(value: false);
  bool isLoading = false;

  String privacyPolicyLink = null;

  final HttpService httpService = HttpService();

  @override
  void initState() {
    httpService.getPrivacyPolicyLink().then((value) {
      privacyPolicyLink = value;
    });
    super.initState();
  }


  void _showCenterFlash(
      {FlashPosition position,
        FlashStyle style,
        Alignment alignment,
        String text}) {
    showFlash(
      context: context,
      duration: Duration(seconds: 2),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.black87,
          borderRadius: BorderRadius.circular(8.0),
          borderColor: Color(0xFF6740FB),
          position: position,
          style: style,
          alignment: alignment,
          enableDrag: false,
          onTap: () => controller.dismiss(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white, fontFamily: 'Ginto'),
              child: Text(
                text,
              ),
            ),
          ),
        );
      },
    ).then((_) {
      if (_ != null) {
        _showMessage(_.toString());
      }
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (_, controller) {
          return Flash(
            controller: controller,
            position: FlashPosition.top,
            style: FlashStyle.grounded,
            child: FlashBar(
              icon: Icon(
                Icons.face,
                size: 36.0,
                color: Colors.black,
              ),
              message: Text(message),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    EdgeInsets textFieldInsets = EdgeInsets.fromLTRB(
        width * 0.06, height * 0.022, width * 0.06, -height * 0.016);
    EdgeInsets buttonInsets = EdgeInsets.fromLTRB(
        width * 0.06, height * 0.022, width * 0.06, height * 0.022);

    TextStyle style = TextStyle(
        color: Color(0xFFDCDCDC), fontFamily: 'Ginto', fontSize: 14.0);
    TextStyle hintStyle = TextStyle(
        color: Color(0xFFAAAAAA), fontFamily: 'Ginto', fontSize: 14.0);
    final emailField = TextField(
        obscureText: false,
        style: style,
        onChanged: (String notUsed) {
          setState(() {
            _emailIsMissing = false;
            _emailIsWrongFormat = false;
            _accountAlreadyExist = false;
          });
        },
        controller: emailController,
        decoration: InputDecoration(
            contentPadding: textFieldInsets,
            hintText: "Email",
            hintStyle: hintStyle,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _emailIsMissing ||
                            _emailIsWrongFormat ||
                            _accountAlreadyExist
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 2.0)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _emailIsMissing ||
                            _emailIsWrongFormat ||
                            _accountAlreadyExist
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 3.0)),
            errorText: (_emailIsWrongFormat)
                ? "email is in wrong format"
                : (_accountAlreadyExist) ? "email is already in use" : null,
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _emailIsMissing ||
                            _emailIsWrongFormat ||
                            _accountAlreadyExist
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 2.0)),
            focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _emailIsMissing ||
                            _emailIsWrongFormat ||
                            _accountAlreadyExist
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 3.0))));
    final fullName = TextField(
        obscureText: false,
        style: style,
        onChanged: (String notUsed) {
          setState(() {
            _fullNameIsMissing = false;
          });
        },
        controller: fullNameController,
        decoration: InputDecoration(
            contentPadding: textFieldInsets,
            hintText: "Full name",
            hintStyle: hintStyle,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _fullNameIsMissing
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 2.0)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _fullNameIsMissing
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 3.0))));

    final phoneNr = TextField(
        obscureText: false,
        style: style,
        controller: phoneNumberController,
        onChanged: (String notUsed) {
          setState(() {
            _phoneNumberIsMissing = false;
          });
        },
        decoration: InputDecoration(
            contentPadding: textFieldInsets,
            hintText: "Mobile number",
            hintStyle: hintStyle,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _phoneNumberIsMissing
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 2.0)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _phoneNumberIsMissing
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 3.0))));

    final programme = TextField(
        obscureText: false,
        style: style,
        onChanged: (String notUsed) {
          setState(() {
            _programmeAndYearOfAdmissionIsMissing = false;
          });
        },
        controller: programmeAndYearOfAdmissionController,
        decoration: InputDecoration(
            contentPadding: textFieldInsets,
            hintText: "Programme & year of admission",
            hintStyle: hintStyle,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _programmeAndYearOfAdmissionIsMissing
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 2.0)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _programmeAndYearOfAdmissionIsMissing
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 3.0))));

    final member = Theme(
        data: ThemeData(unselectedWidgetColor: Color(0xFF6740FB)),
        child: CheckboxListTile(
            title: Text("I'm a member of the Chalmers Student Union",
                style: TextStyle(color: Color(0xFFDCDCDC), fontSize: 12)),
            value: _isMember,
            onChanged: (bool value) {
              setState(() {
                _isMember = value;
              });
            },
            activeColor: Color(0xFF6740FB),
            checkColor: Color(0xFFDCDCDC)));

    final partOfChalmers = Theme(
        data: ThemeData(unselectedWidgetColor: Color(0xFF6740FB)),
        child: CheckboxListTile(
            title: Text("I'm a student, alumni or employee at Chalmers",
                style: TextStyle(color: Color(0xFFDCDCDC), fontSize: 12)),
            value: _isPartOfChalmers,
            onChanged: (bool value) {
              setState(() {
                _isPartOfChalmers = value;
              });
            },
            activeColor: Color(0xFF6740FB),
            checkColor: Color(0xFFDCDCDC)));

    final privatePolicy = Theme(
        data: ThemeData(unselectedWidgetColor: Color(0xFF6740FB)),
        child: CheckboxListTile(
            title: Text("I have read and agreed CWA:s privacy policy*",
                style: TextStyle(color: Color(0xFFDCDCDC), fontSize: 12)),
            value: _isPolicy,
            onChanged: (bool value) {
              setState(() {
                _isPolicy = value;
              });
            },
            activeColor: Color(0xFF6740FB),
            checkColor: Color(0xFFDCDCDC)));

    final registerButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30.0),
      color: (_isPartOfChalmers && _isPolicy) ? Color(0xFF6740FB) : Colors.grey,
      child: MaterialButton(
        minWidth: width,
        padding: buttonInsets,
        onPressed: (_isPartOfChalmers && _isPolicy)
            ? () async {
                if (this.mounted) {
                  setState(() {
                    isLoading = true;
                  });
                }
          List<RegisterReturn> registerReturn = await httpService.register(
              emailController.text,
              phoneNumberController.text,
              fullNameController.text,
              programmeAndYearOfAdmissionController.text,
              _isMember,
            _isPartOfChalmers,
            _isPolicy
          );
          if (registerReturn.contains(RegisterReturn.success) && _isPartOfChalmers && _isPolicy) {
            String loggedIn = await httpService.login(emailController.text, phoneNumberController.text);
            if (loggedIn != null) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context, true);
                Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute( builder: (context) => Navigation(memberId: loggedIn)), ModalRoute.withName('/'));});
            } else {
              _showCenterFlash(
                  position: FlashPosition.top,
                  style: FlashStyle.floating,
                  text: "Register succesful but error logging in, try loggin in later"
              );
            }
          } else {
            if (this.mounted) {
              setState(() {
                if (registerReturn
                    .contains(RegisterReturn.missingField_email))
                  _emailIsMissing = true;
                if (registerReturn
                    .contains(RegisterReturn.missingField_phoneNumber))
                  _phoneNumberIsMissing = true;
                if (registerReturn
                    .contains(RegisterReturn.missingField_fullName))
                  _fullNameIsMissing = true;
                if (registerReturn.contains(RegisterReturn
                    .missingField_programmeAndYearOfAdmission))
                  _programmeAndYearOfAdmissionIsMissing = true;
                if (registerReturn.contains(RegisterReturn.wrongEmail))
                  _emailIsWrongFormat = true;
                if (registerReturn
                    .contains(RegisterReturn.accountAlreadyExist))
                  _accountAlreadyExist = true;
              });
            }
          }
                /*
                if(registerReturn.contains(RegisterReturn.unknown_error)){
                  print("Unknown error upon registering");
                }
                */
          if (this.mounted) {
            setState(() {
              isLoading = false;
            });
          }
        } : null,
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
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.06,
                      bottom: height * 0.03),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 357),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 16.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: width / 12, right: width / 12),
                        child: fullName,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: height / 46,
                            left: width / 12,
                            right: width / 12),
                        child: emailField,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: height / 46,
                            left: width / 12,
                            right: width / 12),
                        child: phoneNr,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: height / 46,
                            left: width / 12,
                            right: width / 12),
                        child: programme,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: height / 28,
                            left: width / 12,
                            right: width / 12),
                        child: member,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: width / 12, right: width / 12),
                        child: partOfChalmers,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: width / 12, right: width / 12),
                        child: privatePolicy,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: height / 40,
                            left: width / 12,
                            right: width / 12),
                        child: ScaledAnimation(
                            hasPlayed: hasPlayed,
                            key: UniqueKey(),
                            delay_milliseconds: 500,
                            child: !isLoading
                                ? registerButton
                                : Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Color(0xFF6740FB))))),
                      ),
                    ],
                  )),
              Padding(
                  padding:
                      EdgeInsets.only(top: height / 60, bottom: height / 60),
                  child: FutureBuilder(
                    future: httpService.getPrivacyPolicyLink(),
                    builder:(context, snapshot) {
                      if(snapshot.hasData){
                      return ShowUpAnimation(
                      //delayStart: Duration(milliseconds: 700),
                      animationDuration: Duration(seconds: 1),
                      curve: Curves.bounceIn,
                      direction: Direction.vertical,
                      offset: 0.5,
                      child: new InkWell(
                          child: new Text('*Privacy policy',
                              style: new TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'Ginto',
                                  fontSize: 12.0)),
                          onTap: () async {
                            if(await canLaunch(snapshot.data)){
                              launch(snapshot.data);
                            } else {
                              _showCenterFlash(
                                  position: FlashPosition.top,
                                  style: FlashStyle.floating,
                                  text: "Privacy Policy temporarily unavailable. Come back later.");
                            }
                          }),
                    );}
                      return Container(width: 0, height: 12,);
                      },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
