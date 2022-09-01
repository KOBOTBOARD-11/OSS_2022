import 'package:booriya/Colors.dart';
import 'package:booriya/common/info_form_field.dart';
import 'package:booriya/styles.dart';
import 'package:flutter/material.dart';

class FireInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("화재 발생 정보"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/on", (route) => false);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      endDrawer: _buildBooriyaDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              _buildVideo(),
              _buildInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideo() {
    return Column(
      children: [
        Text(
          "화재 발생 영상",
          style: h5(),
        ),
        Container(
          width: 320,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      children: [
        Text(
          "화재 발생 상세 정보",
          style: h5(),
        ),
        Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: backgroundColor(),
          ),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoFormField(
                  titleText: "1. 화재 감지 시간",
                  infoText: "2022-08-30, 00:00:00",
                ),
                SizedBox(height: 10),
                InfoFormField(
                  titleText: "2. 장소",
                  infoText: "성북 코보 레스토랑",
                ),
                SizedBox(height: 10),
                InfoFormField(
                  titleText: "3. 발화 장소",
                  infoText: "1층 로비(CCTV 1)",
                ),
              ],
            ),
          ),
        ),
      ],
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
