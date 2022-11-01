import 'package:booriya/styles.dart';
import 'package:flutter/material.dart';

// 받아온 데이터의 title과 info를 한 container로 묶어주는 클래스
class InfoFormField extends StatefulWidget {
  final titleText; // ex)  1. 화재 감지 시간
  final infoText; // ex) ['2022년 09월 14일 21시 49분 29초']

  const InfoFormField({required this.titleText, required this.infoText});
  @override
  State<InfoFormField> createState() =>
      _InfoFormFieldState(titleText, infoText);
}

class _InfoFormFieldState extends State<InfoFormField> {
  final titleText;
  final infoText;
  _InfoFormFieldState(this.titleText, this.infoText);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 10),
            child: Text(
              titleText,
              style: subtitle3(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Text(
              infoText,
              style: body1(),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
