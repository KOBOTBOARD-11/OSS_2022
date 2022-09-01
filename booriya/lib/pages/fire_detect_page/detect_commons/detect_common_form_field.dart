import 'package:flutter/material.dart';
import '../../../Colors.dart';
import '../../../common/info_form_field.dart';

class DetectCommonFormField extends StatelessWidget {
  // final humanImage;
  final detectTimeText;
  final detectCountText;

  const DetectCommonFormField(
      {required this.detectTimeText, required this.detectCountText});

  // const DetectCommonFormField({required this.humanImage, required this.detectInfoText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 200,
          // 인원 감지 이미지
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor(),
          ),
          child: Column(
            children: [
              InfoFormField(
                titleText: detectTimeText[0],
                infoText: detectTimeText[1],
              ),
              InfoFormField(
                titleText: detectCountText[0],
                infoText: detectCountText[1],
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}
