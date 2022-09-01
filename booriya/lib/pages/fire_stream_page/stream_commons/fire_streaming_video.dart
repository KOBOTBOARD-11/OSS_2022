import 'package:booriya/styles.dart';
import 'package:flutter/material.dart';

class FireStreamingVideo extends StatelessWidget {
  final String cctvName;

  const FireStreamingVideo({required this.cctvName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Text(
            "${cctvName}",
            style: subtitle3(),
          ),
          SizedBox(height: 15),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
