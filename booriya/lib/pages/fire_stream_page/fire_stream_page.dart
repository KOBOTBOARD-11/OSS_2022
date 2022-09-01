import 'package:booriya/pages/fire_stream_page/stream_commons/fire_streaming_video.dart';
import 'package:booriya/styles.dart';
import 'package:flutter/material.dart';

import '../../Colors.dart';

// class StreamArguments {
//   final String cctvName;
//
//   StreamArguments({required this.cctvName});
// }

class FireStreamPage extends StatelessWidget {
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
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            FireStreamingVideo(cctvName: "1층 로비"),
            FireStreamingVideo(cctvName: "1층 조리실"),
          ],
        ),
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
