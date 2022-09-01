import 'package:booriya/pages/fire_detect_page/fire_detect_page_detail.dart';
import 'package:booriya/pages/fire_detect_page/fire_detect_page.dart';
import 'package:booriya/pages/fire_info_page/fire_info_page.dart';
import 'package:booriya/pages/fire_off_page/fire_off.dart';
import 'package:booriya/pages/fire_on_page/fire_on.dart';
import 'package:booriya/pages/fire_stream_page/fire_stream_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFE26A2C),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/off",
      routes: {
        "/on": (context) => FireOn(),
        "/off": (context) => FireOff(),
        "/info": (context) => FireInfoPage(),
        "/detect": (context) => FireDetectPage(),
        "/detail": (context) => Detail(),
        "/stream": (context) => FireStreamPage(),
      },
    );
  }
}
