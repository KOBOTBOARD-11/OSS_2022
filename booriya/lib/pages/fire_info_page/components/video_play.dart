import 'package:booriya/Colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({required this.url});
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(url);
}

// 최초 화재 발생 상황의 비디오 영상을 보여준다.
class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  final String url;

  _VideoPlayerScreenState(this.url);

  @override
  void initState() {
    _controller = VideoPlayerController.network(url);
    _controller.initialize().then((value) {
      _controller.play();
      // _controller.setLooping(true);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller))
              : const CircularProgressIndicator(),
        ),
        Column(
          children: [
            SizedBox(
              height: 200,
            ),
            FloatingActionButton(
              backgroundColor: appBarColor(),
              onPressed: () {
                setState(() {
                  // 영상이 재생 중이라면, 일시 중지 시킨다.
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                    Icon(Icons.play_arrow);
                  } else {
                    // 만약 영상이 일시 중지 상태였다면, 재생시킨다.
                    _controller.play();
                    Icon(Icons.pause);
                  }
                });
              },
              // 플레이어의 상태에 따라 올바른 아이콘을 보여준다.
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
