import 'dart:async';

import 'package:booriya/pages/fire_detect_page/fire_detect_page_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Colors.dart';
import '../../common/fire_drawer.dart';
import '../../styles.dart';
import 'detect_info_datalist.dart';

class FireDetectPage extends StatefulWidget {
  @override
  State<FireDetectPage> createState() => _FireDetectPageState();
}

class _FireDetectPageState extends State<FireDetectPage> {
  // StreamController streamctrl = StreamController();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    var _snapshot = FirebaseFirestore.instance.collection('Human').snapshots();
    //print("hi");
    return Scaffold(
      appBar: AppBar(
        title: Text("화재 발생 정보"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/on", (route) => false);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      endDrawer: _buildBooriyaDrawer(context),
      body: StreamBuilder<QuerySnapshot>(
          stream: _snapshot,
          builder: (context, snapshot) {
            if (snapshot.data!.docs.isEmpty) {
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
                  snapshot.data!.docs.last['date'] != detectInfo.last['date']) {
                detectInfo.add(snapshot.data!.docs.last.data());
                print(detectInfo);
              }

              return Align(
                alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: detectInfo.length,
                  itemBuilder: (context, index) {
                    return _buildDetectButton(
                      detectInfo[index]['cctvName'],
                      detectInfo[index]['date']!.toDate(),
                      detectInfo[index]['count'],
                      context,
                    );
                  },
                ),
              );
            }
          }),
    );
  }

  Widget _buildDetectButton(
      String cctvName, DateTime date, String count, BuildContext context) {
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
                          cctvName: cctvName, date: date, count: count),
                    );
                  },
                  child: Text(
                    cctvName,
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

  Drawer _buildBooriyaDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          AppBar(
            title: Text("MENU"),
            backgroundColor: appColor1(),
          ),
          SizedBox(height: 10),
          BuildDrawerTextButton("HOME", context),
          BuildDrawerTextButton("화재 정보", context),
          BuildDrawerTextButton("실시간 스트리밍", context),
        ],
      ),
    );
  }
}
