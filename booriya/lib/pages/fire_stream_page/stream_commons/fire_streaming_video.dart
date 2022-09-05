import 'dart:convert';
import 'dart:typed_data';

import 'package:booriya/Colors.dart';
import 'package:flutter/material.dart';
import 'websockets.dart';

class VideoStream extends StatefulWidget {
  const VideoStream({Key? key}) : super(key: key);

  @override
  State<VideoStream> createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  final WebSocket _socket = WebSocket("ws://172.20.144.1:6000");
  bool _isConnected = false;
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
        // color: appColor3(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("1층 로비(CCTV 1)",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
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
                : const Text("1층 조리실(CCTV 1)에 연결하세요.")
          ],
        ),
      ),
    );
  }
}
