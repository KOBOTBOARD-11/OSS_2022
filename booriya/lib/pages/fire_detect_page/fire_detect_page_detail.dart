import 'package:booriya/common/info_form_field.dart';
import 'package:booriya/styles.dart';
import 'package:flutter/material.dart';

import '../../Colors.dart';
import 'detect_commons/detect_common_form_field.dart';

class DetailArguments {
  final String cctvName;
  final DateTime date;
  final String count;

  DetailArguments(
      {required this.cctvName, required this.date, required this.count});
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DetailArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("화재 발생 정보"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/detect", (route) => false);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      endDrawer: _buildBooriyaDrawer(context),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/stream");
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  args.cctvName,
                  style: subtitle3(),
                ),
              ),
            ),
          ),
          DetectCommonFormField(
            detectTimeText: ["인원 감지 시각", "${args.date}"],
            detectCountText: ["감지 인원 수", "${args.count}명"],
          ),
        ],
      ),
    );
  }

  Drawer _buildBooriyaDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          AppBar(
            title: Text("MENU"),
            backgroundColor: appColor1(),
          ),
          SizedBox(height: 10),
          _buildDrawerTextButton("HOME", context),
          _buildDrawerTextButton("실시간 스트리밍", context),
          _buildDrawerTextButton("화재 정보", context),
          _buildDrawerTextButton("인원 감지", context),
        ],
      ),
    );
  }

  Widget _buildDrawerTextButton(String DrawerText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          switch (DrawerText) {
            case "HOME":
              {
                DrawerText = "on";
              }
              break;
            case "실시간 스트리밍":
              {
                DrawerText = "stream";
              }
              break;
            case "화재 정보":
              {
                DrawerText = "info";
              }
              break;
            case "인원 감지":
              {
                DrawerText = "detect";
              }
              break;
          }
          Navigator.pushNamedAndRemoveUntil(
              context, "/${DrawerText}", (route) => false);
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
}
