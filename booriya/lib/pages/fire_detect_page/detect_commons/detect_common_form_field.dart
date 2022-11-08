import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import '../../../../Colors.dart';
import '../../../../common/info_form_field.dart';

// FireDetectPageDetail 페이지에서 snapshot을 통해 가져온 데이터들을 보여준다.
class DetectCommonFormField extends StatelessWidget {
  final detectTimeText;
  final detectCountText;
  final imageUrl;

  const DetectCommonFormField(
      {required this.imageUrl,
      required this.detectTimeText,
      required this.detectCountText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            // 탐지된 순간의 이미지를 보여준다.
            child: ExtendedImage.network(
              imageUrl,
              fit: BoxFit.cover,
              cache: false,
            ),
          ),
        ),
        const SizedBox(height: 10),
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
        const SizedBox(height: 40),
      ],
    );
  }
}
