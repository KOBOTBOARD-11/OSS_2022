import 'package:booriya/Colors.dart';
import 'package:booriya/pages/fire_info_page/fire_info_page.dart';
import 'package:booriya/pages/fire_on_page/fire_on.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FireInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print([url, location, roomName, date].runtimeType);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FireInfoPage(
              dataList: [url, location, roomName, date],
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        height: 140,
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(height: 15),
            Icon(
              CupertinoIcons.doc,
              size: 80,
              color: Colors.white,
            ),
            Text(
              "화재 정보",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: appColor2(),
        ),
      ),
    );
  }
}
