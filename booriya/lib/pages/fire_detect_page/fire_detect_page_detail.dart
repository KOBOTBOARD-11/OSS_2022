import 'package:booriya/styles.dart';
import 'package:flutter/material.dart';

import '../../Colors.dart';
import 'detect_commons/detect_common_form_field.dart';

class DetailArguments {
  final String cctvName;
  final DateTime date;
  final String count;

  DetailArguments(
      {required this.cctvName, required this.date, required this.count});
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DetailArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("인원 감지 내역"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/stream");
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  args.cctvName,
                  style: subtitle3(),
                ),
              ),
            ),
          ),
          DetectCommonFormField(
            detectTimeText: ["인원 감지 시각", "${args.date}"],
            detectCountText: ["감지 인원 수", "${args.count}명"],
          ),
        ],
      ),
    );
  }
}
