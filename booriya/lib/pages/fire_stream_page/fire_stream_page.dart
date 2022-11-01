import 'package:booriya/pages/fire_stream_page/stream_commons/fire_streaming_video.dart';
import 'package:flutter/material.dart';

// 실시간 cctv의 화면을 스트리밍을 통해 볼 수 있는 page
class FireStreamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("실시간 스트리밍")),
      body: ListView(
        children: const [
          VideoStream(cameraNum: 1),
          VideoStream(cameraNum: 2),
        ],
      ),
    );
  }
}
