import 'package:booriya/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FireStreaming extends StatelessWidget {
  const FireStreaming({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/stream");
      },
      child: Container(
        width: 300,
        height: 180,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: appBarColor(),
        ),
        child: Column(
          children: const [
            Icon(
              CupertinoIcons.clock,
              size: 100,
              color: Colors.white,
            ),
            Text(
              "인원 감지\n실시간 스트리밍",
              style: TextStyle(
                fontSize: 20,
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
