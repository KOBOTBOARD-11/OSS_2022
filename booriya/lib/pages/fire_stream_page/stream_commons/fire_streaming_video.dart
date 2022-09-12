import 'dart:convert';
import 'dart:typed_data';
import 'package:booriya/Colors.dart';
import 'package:flutter/material.dart';
import 'websockets.dart';
import 'camera_list.dart';

class VideoStream extends StatefulWidget {
  const VideoStream({Key? key, required this.cameraNum}) : super(key: key);
  final int cameraNum;

  @override
  State<VideoStream> createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  late WebSocket _socket;
  late List<String> cameraInfo;
  bool _isConnected = false;

  @override
  void initState() {
    cameraInfo = cameraList[widget.cameraNum];
    _socket = WebSocket("ws://${cameraList[widget.cameraNum][1]}");
  }

  void connect(BuildContext context) async {
    _socket.connect();
    setState(() {
      _isConnected = true;
    });
    print('Try to connect server!');
  }

  void disconnect() {
    _socket.disconnect();
    setState(() {
      _isConnected = false;
    });
    print('Server disconnected!');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: appColor3(),
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${cameraList[widget.cameraNum][0]}(CCTV ${widget.cameraNum})",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
                _isConnected
                    ? ElevatedButton(
                        onPressed: disconnect,
                        style: TextButton.styleFrom(
                          backgroundColor: appColor2(),
                        ),
                        child: const Text("닫기"),
                      )
                    : ElevatedButton(
                        onPressed: () => connect(context),
                        style: TextButton.styleFrom(
                          backgroundColor: appColor2(),
                        ),
                        child: const Text("연결하기"),
                      )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            _isConnected
                ? StreamBuilder(
                    stream: _socket.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        print('socket does not have data!');
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        return const Center(
                          child: Text("Connection Closed !"),
                        );
                      }
                      //? Working for single frames
                      return Image.memory(
                        Uint8List.fromList(
                          base64Decode(
                            (snapshot.data.toString()),
                          ),
                        ),
                        gaplessPlayback: true,
                        excludeFromSemantics: true,
                      );
                    },
                  )
                : Text(
                    "${cameraList[widget.cameraNum][0]}(CCTV ${widget.cameraNum})에 연결하세요.")
          ],
        ),
      ),
    );
  }
}
