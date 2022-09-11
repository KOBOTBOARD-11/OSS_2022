import 'package:booriya/pages/fire_stream_page/stream_commons/fire_streaming_video.dart';
import 'package:flutter/material.dart';

class FireStreamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("화재 발생 정보")),
      // endDrawer: _buildBooriyaDrawer(context),
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
