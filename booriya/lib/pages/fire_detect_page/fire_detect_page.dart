import 'package:booriya/pages/fire_detect_page/fire_detect_page_detail.dart';
import 'package:flutter/material.dart';
import '../../Colors.dart';
import '../../styles.dart';

class FireDetectPage extends StatelessWidget {
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
      body: Align(
        alignment: Alignment.center,
        child: ListView(
          children: [
            _buildDetectButton("1층 로비(CCTV 1)", context),
            _buildDetectButton("1층 조리실(CCTV 2)", context),
            // _buildDetectButton("2층 조리실(CCTV 3)", context),
            // _buildDetectButton("2층 엘리베이터(CCTV 4)", context),
            // _buildDetectButton("3층 로비(CCTV 5)", context),
            // _buildDetectButton("4층 로비(CCTV 6)", context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectButton(String cctvName, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            height: 110,
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: backgroundColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/detail",
                  arguments: DetailArguments(cctvName: cctvName),
                );
              },
              child: Text(
                cctvName,
                style: h5(),
              ),
            ),
          ),
        )
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
          _buildDrawerTextButton("화재 정보", context),
          _buildDrawerTextButton("실시간 스트리밍", context),
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
            case "실시간 스트리밍":
              {
                DrawerText = "stream";
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
