import 'package:cwa_application/Bool.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'http_service.dart';

class ContactUs extends StatefulWidget {
  final String memberId;

  const ContactUs({Key key, @required this.memberId}) : super(key: key);
  @override
  _ContactUs createState() => _ContactUs(memberId: memberId);
}

class _ContactUs extends State<ContactUs> {
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  String memberId;

  bool _subjectIsMissing = false;
  bool _messageIsMissing = false;

  Bool hasPlayed = Bool(value: false);
  bool isloading = false;

  _ContactUs({@required this.memberId});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    EdgeInsets textFieldInsets = EdgeInsets.fromLTRB(
        width * 0.06, height * 0.022, width * 0.06, -height * 0.016);
    EdgeInsets buttonInsets = EdgeInsets.fromLTRB(
        width * 0.06, height * 0.022, width * 0.06, height * 0.022);

    TextStyle style =
        TextStyle(color: Colors.white, fontFamily: 'Ginto', fontSize: 14.0);
    TextStyle hintStyle = TextStyle(
        color: Color(0xFFAAAAAA), fontFamily: 'Ginto', fontSize: 14.0);

    final subject = TextField(
        obscureText: false,
        style: style,
        onTap: () {
          setState(() {
            _subjectIsMissing = false;
          });
        },
        onChanged: (String notUsed) {
          setState(() {
            _subjectIsMissing = false;
          });
        },
        controller: subjectController,
        decoration: InputDecoration(
            contentPadding: textFieldInsets,
            hintText: "Subject",
            hintStyle: hintStyle,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _subjectIsMissing
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 2.0)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _subjectIsMissing
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 3.0))));

    final message = TextField(
        obscureText: false,
        style: style,
        onTap: () {
          setState(() {
            _messageIsMissing = false;
          });
        },
        onChanged: (String notUsed) {
          setState(() {
            _messageIsMissing = false;
          });
        },
        controller: messageController,
        decoration: InputDecoration(
            contentPadding: textFieldInsets,
            hintText: "Message",
            hintStyle: hintStyle,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _messageIsMissing
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 2.0)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: _messageIsMissing
                        ? Color(0xFFFF4040)
                        : Color(0xFF6740FB),
                    width: 3.0))));

    final sendButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF6740FB),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: buttonInsets,
        onPressed:  !isloading
            ? () async {
          if (this.mounted) {
            setState(() {
              isloading = true;
            });
          }
          final HttpService httpService = HttpService();
          List<ContactReturn> contactReturn = await httpService.sendMessage(
              memberId,
              subjectController.text,
              messageController.text);

          print(contactReturn);

          if (contactReturn.contains(ContactReturn.success)) {
            _showCenterFlash(
                position: FlashPosition.top,
                style: FlashStyle.floating,
                text: "Message sent!");
            messageController.clear();
            subjectController.clear();
          } else {
            setState(() {
              if (contactReturn.contains(ContactReturn.missingField_subject))
                _subjectIsMissing = true;
              if (contactReturn.contains(ContactReturn.missingField_message))
                _messageIsMissing = true;
            });
          }
          setState(() {
            isloading = false;
          });
        } : null,
        child: RichText(
          text: TextSpan(
            text: 'Send',
            style: TextStyle(
              fontFamily: 'Ginto',
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );

    return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: width / 12, right: width / 12),
                  child: subject,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height / 46, left: width / 12, right: width / 12),
                  child: message,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height / 15, left: width / 12, right: width / 12),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height / 40, left: width / 12, right: width / 12),
                  child: !isloading ? sendButton
                    : CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Color(0xFF6740FB))),
                ),
              ],
            );
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
            style: FlashStyle.floating,
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
}
