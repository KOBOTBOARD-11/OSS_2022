import 'package:booriya/Colors.dart';
import 'package:booriya/common/info_form_field.dart';
import 'package:booriya/styles.dart';
import 'package:flutter/material.dart';

import 'components/video_play.dart';

class FireInfoPage extends StatelessWidget {
  final dataList;

  const FireInfoPage({this.dataList});

  @override
  Widget build(BuildContext context) {
    var url = dataList[0];
    var location = dataList[1];
    var roomName = dataList[2];
    var date = dataList[3];
    return Scaffold(
      appBar: AppBar(
        title: const Text("화재 발생 정보"),
      ),
      // endDrawer: _buildBooriyaDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            children: [
              _buildVideo(url),
              _buildInfo(location, roomName, date.substring(4, 27)),
            ],
          ),
        ),
      ),
    );
  }

  // video 화면을 구성한다.
  Widget _buildVideo(String url) {
    return Column(
      children: [
        Text(
          "화재 발생 영상",
          style: h5(),
        ),
        const SizedBox(height: 10),
        VideoPlayerScreen(url: url),
        const SizedBox(height: 10),
      ],
    );
  }

  // 화재 발생 상세 정보를 구성한다.
  Widget _buildInfo(String location, String roomName, String date) {
    return Column(
      children: [
        Text(
          "화재 발생 상세 정보",
          style: h5(),
        ),
        const SizedBox(height: 10),
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
                  infoText: date,
                ),
                const SizedBox(height: 10),
                InfoFormField(
                  titleText: "2. 장소",
                  infoText: location,
                ),
                const SizedBox(height: 10),
                InfoFormField(
                  titleText: "3. 발화 장소",
                  infoText: roomName,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
