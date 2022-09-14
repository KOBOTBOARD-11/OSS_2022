import 'package:booriya/pages/fire_detect_page/fire_detect_page_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Colors.dart';
import '../../confirm_and_notice/notification.dart';
import '../../styles.dart';
import 'detect_info_datalist.dart';

class FireDetectPage extends StatefulWidget {
  @override
  State<FireDetectPage> createState() => _FireDetectPageState();
}

class _FireDetectPageState extends State<FireDetectPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    var _snapshot =
        FirebaseFirestore.instance.collection('fire situation_C').snapshots();
    //print("hi");
    return Scaffold(
      appBar: AppBar(
        title: Text("인원 감지 내역"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _snapshot,
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.data?.size == 0) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text(
                    "No Data",
                    style: h4(),
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: backgroundColor(),
                child: Center(
                  child: CircularProgressIndicator(color: appBarColor()),
                ),
              );
            } else {
              if (detectInfo.isEmpty ||
                  snapshot.data?.docs.last['detected_Time'] !=
                      detectInfo.last['detected_Time']) {
                //showHumanDetectNotification();
                detectInfo.add(snapshot.data?.docs.last.data());
              }
              return Align(
                alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: detectInfo.length,
                  itemBuilder: (context, index) {
                    return _buildDetectButton(
                      detectInfo[index]['FireImage'],
                      detectInfo[index]['Room_name'],
                      detectInfo[index]['detected_Time'],
                      detectInfo[index]['HumanCount'],
                      context,
                    );
                  },
                ),
              );
            }
          }),
    );
  }

  Widget _buildDetectButton(String imageUrl, String cctvName, String date,
      String count, BuildContext context) {
    return Dismissible(
      key: Key(cctvName),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: backgroundColor(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/detail",
                      arguments: DetailArguments(
                          imageUrl: imageUrl,
                          cctvName: cctvName,
                          date: date,
                          count: count),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    "${cctvName}\n${date.substring(4, 27)}",
                    style: h5(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
