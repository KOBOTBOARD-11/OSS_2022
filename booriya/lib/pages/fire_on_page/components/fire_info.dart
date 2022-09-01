import 'package:booriya/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FireInfo extends StatelessWidget {
  const FireInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/info");
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
