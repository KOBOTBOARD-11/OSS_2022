import 'package:booriya/pages/fire_detect_page/detect_info_datalist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Colors.dart';
import '../styles.dart';

// 화재 진화 완료 여부(예 또는 아니오)를 묻는 다이얼로그
CheckDialogYesOrNo(BuildContext context) {
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
                  CheckDialogConfirm(context);
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

// CheckDialogYesOrNo에서 예를 누를 시 확인 문구를 보여주는 다이얼로그
CheckDialogConfirm(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      //detectInfo.clear();
      //FirebaseFirestore.instance.collection('Human')
      return AlertDialog(
        // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        //Dialog Main Title
        //
        content: Text(
          "화재 진화가\n완료되었습니다.",
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
                  "확인",
                  style: subtitle3(mColor: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/off", (route) => false);
                },
              ),
            ],
          )
        ],
      );
    },
  );
}
