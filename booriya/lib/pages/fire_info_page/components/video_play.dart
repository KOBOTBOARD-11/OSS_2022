import 'package:booriya/Colors.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({required this.url});
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(url);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late CachedVideoPlayerController _controller;
  final String url;

  _VideoPlayerScreenState(this.url);

  @override
  void initState() {
    _controller = CachedVideoPlayerController.network(url);
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
                  child: CachedVideoPlayer(_controller))
              : const CircularProgressIndicator(),
        ), // This trailing comma makes auto-formatting nicer for build methods.
        Column(
          children: [
            SizedBox(
              height: 200,
            ),
            FloatingActionButton(
              backgroundColor: appBarColor(),
              onPressed: () {
                // 재생/일시 중지 기능을 `setState` 호출로 감쌉니다. 이렇게 함으로써 올바른 아이콘이
                // 보여집니다.
                setState(() {
                  // 영상이 재생 중이라면, 일시 중지 시킵니다.
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                    Icon(Icons.play_arrow);
                  } else {
                    // 만약 영상이 일시 중지 상태였다면, 재생합니다.
                    _controller.play();
                    Icon(Icons.pause);
                  }
                });
              },
              // 플레이어의 상태에 따라 올바른 아이콘을 보여줍니다.
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
