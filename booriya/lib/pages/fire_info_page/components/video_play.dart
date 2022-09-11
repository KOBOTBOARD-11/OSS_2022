import 'package:booriya/Colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({required this.url});
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(url);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  final String url;

  _VideoPlayerScreenState(this.url);
  @override
  void initState() {
    // VideoPlayerController를 저장하기 위한 변수를 만듭니다. VideoPlayerController는
    // asset, 파일, 인터넷 등의 영상들을 제어하기 위해 다양한 생성자를 제공합니다.
    _controller = VideoPlayerController.network(
      "https://firebasestorage.googleapis.com/v0/b/firefire-ca4d0.appspot.com/o/fire?alt=media&token=1",
    );

    // 컨트롤러를 초기화하고 추후 사용하기 위해 Future를 변수에 할당합니다.
    _initializeVideoPlayerFuture = _controller.initialize();

    // 비디오를 반복 재생하기 위해 컨트롤러를 사용합니다.
    // _controller.setLooping(false);

    super.initState();
  }

  @override
  void dispose() {
    // 자원을 반환하기 위해 VideoPlayerController를 dispose 시키세요.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // VideoPlayerController가 초기화를 진행하는 동안 로딩 스피너를 보여주기 위해
        // FutureBuilder를 사용합니다.
        Stack(
      alignment: Alignment.center,
      children: [
        FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // 만약 VideoPlayerController 초기화가 끝나면, 제공된 데이터를 사용하여
              // VideoPlayer의 종횡비를 제한하세요.
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // 영상을 보여주기 위해 VideoPlayer 위젯을 사용합니다.
                child: VideoPlayer(_controller),
              );
            } // if
            else {
              // 만약 VideoPlayerController가 여전히 초기화 중이라면,
              // 로딩 스피너를 보여줍니다.
              return Container(
                width: 420,
                height: 270,
                color: backgroundColor(),
                child: Center(
                  child: CircularProgressIndicator(color: appBarColor()),
                ),
              );
            } //else
          }, //builder
        ),
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

    // 이 마지막 콤마는 build 메서드에 자동 서식이 잘 적용될 수 있도록 도와줍니다.
  }
}
