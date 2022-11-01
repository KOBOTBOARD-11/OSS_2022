import 'package:booriya/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FireDetect extends StatelessWidget {
  const FireDetect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/detect");
      },
      child: Container(
        width: 140,
        height: 140,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: appColor1(),
        ),
        child: Column(
          children: const [
            SizedBox(height: 15),
            Icon(
              CupertinoIcons.profile_circled,
              size: 80,
              color: Colors.white,
            ),
            Text(
              "인원 감지",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
