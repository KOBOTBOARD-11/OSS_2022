import 'package:booriya/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../fire_info_page/fire_info_page.dart';
import '../fire_on.dart';

class FireInfo extends StatelessWidget {
  const FireInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // print([url, location, roomName, date].runtimeType);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FireInfoPage(
              dataList: [url, location, roomName, date],
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        height: 140,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: appColor1(),
        ),
        child: Column(
          children: const [
            SizedBox(height: 15),
            Icon(
              CupertinoIcons.doc,
              size: 80,
              color: Colors.white,
            ),
            Text(
              "화재 정보",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
