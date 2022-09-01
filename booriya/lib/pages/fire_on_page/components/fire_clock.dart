import 'package:booriya/Colors.dart';
import 'package:flutter/material.dart';

class FireClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "화재 지속 시간",
          style: TextStyle(
            fontSize: 20,
            color: appColor1(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "00:00:00",
          style: TextStyle(
            fontSize: 20,
            color: appColor1(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
