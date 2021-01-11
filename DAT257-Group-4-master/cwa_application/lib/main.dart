import 'package:flutter/material.dart';
import 'startPage.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
// icon source: https://feathericons.com/

void main() {

  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Color(0xFF6740FB)),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      home: MyApp())
  );

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen.navigate(
      name: 'assets/test_loop.flr',
      fit: BoxFit.cover,
      next: (context) => StartPage(),
      startAnimation: 'start',
      loopAnimation: 'loop',
      until: () => Future.delayed(Duration(seconds: 2)),
      endAnimation: 'end',
    );
  }
}
