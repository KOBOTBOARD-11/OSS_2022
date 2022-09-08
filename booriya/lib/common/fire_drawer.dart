import 'package:booriya/pages/fire_info_page/fire_info_page.dart';
import 'package:flutter/material.dart';

import '../Colors.dart';
import '../pages/fire_detect_page/fire_detect_page.dart';
import '../pages/fire_on_page/fire_on.dart';
import '../pages/fire_stream_page/fire_stream_page.dart';
import '../styles.dart';

Widget BuildDrawerTextButton(String DrawerText, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        switch (DrawerText) {
          case "HOME":
            {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => FireOn()),
                  (route) => false);
            }
            break;
          case "실시간 스트리밍":
            {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FireStreamPage(),
                  ),
                  (route) => false);
            }
            break;
          case "인원 감지":
            {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FireDetectPage(),
                  ),
                  (route) => false);
            }
            break;
          case "화재 정보":
            {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FireInfoPage(
                      dataList: [url, location, roomName, date],
                    ),
                  ),
                  (route) => false);
            }
            break;
        }
      },
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          DrawerText,
          style: subtitle2(mColor: appBarColor()),
        ),
      ),
    ),
  );
}
