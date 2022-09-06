import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Colors.dart';
import 'components/fire_detect.dart';
import 'components/fire_finish.dart';
import 'components/fire_info.dart';
import 'components/fire_streaming.dart';
import 'components/fire_clock.dart';

var url;
var location;
var roomName;
var date;

class FireOn extends StatefulWidget {
  @override
  State<FireOn> createState() => _FireOnState();
}

class _FireOnState extends State<FireOn> {
  late Future<List> _dataList;

  void initState() {
    _dataList = _buildDb();
    super.initState();
  }

  Future<List> _buildDb() async {
    var db = FirebaseFirestore.instance;
    var doc_ref = await db.collection("Video").doc('FIRE2022년 09월 01일').get();
    url = doc_ref.data()?['FireVideo'];
    location = doc_ref.data()?['Location'];
    roomName = doc_ref.data()?['Room_name'];
    date = doc_ref.data()?['detected_Time'].toDate();
    List<dynamic> dataList = [url, location, roomName, date];
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBooriyaAppBar(),
      body: FutureBuilder(
        future: _dataList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                FireClock(), // 화재 지속시간
                SizedBox(height: 20),
                FireStreaming(), // 실시간 스트리밍
                SizedBox(height: 40),
                Row(
                  // 화재 정보와 인원 감지
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FireInfo(),
                    SizedBox(width: 20),
                    FireDetect(),
                  ],
                ),
                SizedBox(height: 40),
                FireFinish(), // 화재 진화 완료
              ],
            );
          } else {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: backgroundColor(),
              child: Center(
                child: CircularProgressIndicator(color: appBarColor()),
              ),
            );
          }
        },
      ),
    );
  }

  AppBar _buildBooriyaAppBar() {
    return AppBar(
      title: Text("Booriya"),
      automaticallyImplyLeading: false, // 뒤로가기 버튼 삭제
    );
  }
}
