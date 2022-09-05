import 'dart:convert';
import 'dart:typed_data';

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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => connect(context),
                child: const Text("Connect"),
              ),
              ElevatedButton(
                onPressed: disconnect,
                child: const Text("Disconnect"),
              ),
            ],
          ),
          const SizedBox(
            height: 50.0,
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
              : const Text("Initiate Connection")
        ],
      ),
    );
  }
}
