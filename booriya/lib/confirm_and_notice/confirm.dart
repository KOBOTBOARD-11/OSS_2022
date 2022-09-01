import 'package:flutter/material.dart';

import '../Colors.dart';
import '../styles.dart';

CheckDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        //Dialog Main Title
        //
        content: Text(
          "정말 화재 진화 완료\n버튼을 누르시겠습니까?",
          style: subtitle3(),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              new FlatButton(
                color: buttonColor1(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: new Text(
                  "예",
                  style: subtitle3(mColor: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/off", (route) => false);
                },
              ),
              new FlatButton(
                color: appBarColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: new Text(
                  "아니요",
                  style: subtitle3(mColor: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          )
        ],
      );
    },
  );
}
