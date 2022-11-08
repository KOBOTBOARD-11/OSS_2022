import 'package:booriya/styles.dart';
import 'package:flutter/material.dart';
import 'detect_commons/detect_common_form_field.dart';

class DetailArguments {
  final String imageUrl;
  final String cctvName;
  final String date;
  final String count;

  DetailArguments(
      {required this.imageUrl,
      required this.cctvName,
      required this.date,
      required this.count});
}

class Detail extends StatelessWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DetailArguments;
    print(args.imageUrl);
    return Scaffold(
      appBar: AppBar(
        title: const Text("인원 감지 내역"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
              onPressed: () {
                // 해당 cctv이름의 버튼을 클릭하면 현재 cctv 스트리밍 페이지로도 넘어갈 수 있다.
                Navigator.pushNamed(context, "/stream");
              },
              child: Text(
                args.cctvName,
                style: subtitle3(),
              ),
            ),
          ),
          DetectCommonFormField(
            imageUrl: args.imageUrl,
            detectTimeText: ["인원 감지 시각", (args.date)],
            detectCountText: ["감지 인원 수", "${args.count}명"],
          ),
        ],
      ),
    );
  }
}
