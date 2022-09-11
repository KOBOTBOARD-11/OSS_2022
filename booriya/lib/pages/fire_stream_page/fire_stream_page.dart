import 'package:booriya/pages/fire_stream_page/stream_commons/fire_streaming_video.dart';
import 'package:flutter/material.dart';

class FireStreamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("실시간 스트리밍")),
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
}
