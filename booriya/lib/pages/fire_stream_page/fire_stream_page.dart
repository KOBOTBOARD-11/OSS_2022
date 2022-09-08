import 'package:booriya/pages/fire_stream_page/stream_commons/fire_streaming_video.dart';
import 'package:booriya/styles.dart';
import 'package:flutter/material.dart';

import '../../Colors.dart';
import '../../common/fire_drawer.dart';

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
            // cctv1, 2
            VideoStream(),
            // VideoStream()
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
          BuildDrawerTextButton("HOME", context),
          BuildDrawerTextButton("화재 정보", context),
          BuildDrawerTextButton("인원 감지", context),
        ],
      ),
    );
  }
}
