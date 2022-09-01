import 'package:booriya/Colors.dart';
import 'package:flutter/material.dart';
import '../../../confirm_and_notice/confirm.dart';

class FireFinish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CheckDialog(context),
      child: Container(
        width: 300,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Text(
            "화재 진화 완료",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          color: greyColor(),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
