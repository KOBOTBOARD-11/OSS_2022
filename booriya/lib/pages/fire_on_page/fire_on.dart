import 'package:flutter/material.dart';
import '../../Colors.dart';
import 'components/fire_detect.dart';
import 'components/fire_finish.dart';
import 'components/fire_info.dart';
import 'components/fire_streaming.dart';
import 'components/fire_clock.dart';

class FireOn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBooriyaAppBar(),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          FireClock(), // 화재 지속시간
          SizedBox(height: 20),
          FireStreaming(), // 실시간 스트리밍
          SizedBox(height: 40),
          Row(
            // 화재 정보와 인원 감지
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FireInfo(),
              SizedBox(width: 20),
              FireDetect(),
            ],
          ),
          SizedBox(height: 40),
          FireFinish(), // 화재 진화 완료
        ],
      ),
    );
  }

  AppBar _buildBooriyaAppBar() {
    return AppBar(
      title: Text("Booriya"),
      automaticallyImplyLeading: false, // 뒤로가기 버튼 삭제
    );
  }
}
