import 'package:cwa_application/startPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'http_service.dart';

class AccountPage extends StatefulWidget {
  final String memberId;
  AccountPage({Key key, @required this.memberId}) : super(key: key);
  @override
  _AccountPageState createState() => _AccountPageState(memberId: memberId);
}

class _AccountPageState extends State<AccountPage> {
  String memberId;

  Future<void> alert(BuildContext context, String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          backgroundColor: Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title,
              style: TextStyle(
                  fontSize: 18, fontFamily: 'Ginto', color: Color(0xFFDCDCDC))),
          content: Text(message,
              style: TextStyle(
                  color: Color(0xFFDCDCDC), fontFamily: 'Ginto', fontSize: 14)),
          actions: <Widget>[
            FlatButton(
              child: Text("No",
                  style: TextStyle(
                      color: Color(0xFFDCDCDC),
                      fontFamily: 'Ginto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.02),
              child: FlatButton(
                child: Text(
                  'Yes',
                  style: TextStyle(
                      color: Color(0xFF6740FB),
                      fontFamily: 'Ginto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                onPressed: () async {
                  Navigator.pop(context, true);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StartPage()),
                      ModalRoute.withName('/'));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  final HttpService httpService = HttpService();
  _AccountPageState({@required this.memberId});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final logOutButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF6740FB),
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        minWidth: width / 1.5,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          alert(context, "Log out", "Are you sure you want to log out?");
        },
        child: RichText(
          text: TextSpan(
            text: 'Log out',
            style: TextStyle(
              fontFamily: 'Ginto',
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: height / 8),
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
            FutureBuilder<Set<String>>(
                future: httpService.getMemberInfo(memberId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data != null){
                      return Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                                height: height / 10),
                            Text(snapshot.data.first,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Ginto',
                                    fontSize: 22,
                                    color: Colors.white)),
                            SizedBox(
                                height: height / 30),
                            Text(snapshot.data.last,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Ginto',
                                    fontSize: 18,
                                    color: Colors.white70)),
                          ],
                        ),
                      );
                    } else {
                      return Text("Error fetching user info",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Ginto',
                              fontSize: 20,
                              color: Colors.white));
                    }
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Ginto',
                            fontSize: 20,
                            color: Colors.white));
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                        top: height / 10),
                    child: Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xFF6740FB)))),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: logOutButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
