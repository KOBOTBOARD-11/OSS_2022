import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FireOff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("화재 발생 정보"),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/on");
          },
          child: Container(
            width: 300,
            height: 180,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Icon(
                    Icons.block,
                    size: 90,
                    color: Colors.white,
                  ),
                  Text(
                    "화재 정보가 없습니다.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
