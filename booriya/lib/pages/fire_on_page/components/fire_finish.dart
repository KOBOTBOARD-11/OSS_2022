import 'package:booriya/Colors.dart';
import 'package:flutter/material.dart';

import '../../../../confirm_and_notice/confirm.dart';

class FireFinish extends StatelessWidget {
  const FireFinish({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CheckDialogYesOrNo(context);
      },
      child: Container(
        width: 300,
        height: 100,
        decoration: BoxDecoration(
          color: appColor2(),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Padding(
          padding: EdgeInsets.all(30),
          child: Text(
            "화재 진화 완료",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
