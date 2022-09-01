import 'package:booriya/styles.dart';
import 'package:flutter/material.dart';

class InfoFormField extends StatelessWidget {
  final titleText;
  final infoText;

  const InfoFormField({required this.titleText, required this.infoText});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
