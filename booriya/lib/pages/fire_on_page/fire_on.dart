import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Colors.dart';
import 'components/fire_detect.dart';
import 'components/fire_finish.dart';
import 'components/fire_info.dart';
import 'components/fire_streaming.dart';
import 'components/fire_clock.dart';

var url;
var location;
var roomName;
var date;

// 불이 발생했을 때의 화면을 구성한다.
class FireOn extends StatefulWidget {
  const FireOn({Key? key}) : super(key: key);

  @override
  State<FireOn> createState() => _FireOnState();
}

class _FireOnState extends State<FireOn> {
  late Future<List> _dataList;

  @override
  void initState() {
    _dataList = _buildDb();
    super.initState();
  }

  // firebase로 부터 최초 화재 발생 상황을 받아온다.
  Future<List> _buildDb() async {
    var db = FirebaseFirestore.instance;
    var doc_ref_info =
        await db.collection("first_fireC").doc('first_fireD').get();
    url = doc_ref_info.data()?['FireVideo'];
    location = doc_ref_info.data()?['Location'];
    roomName = doc_ref_info.data()?['Room_name'];
    date = doc_ref_info.data()?['detected_Time'];
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
          //print(fire_on);
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                TimerPage(), // 화재 지속시간
                const SizedBox(height: 20),
                const FireStreaming(), // 실시간 스트리밍
                const SizedBox(height: 40),
                Row(
                  // 화재 정보와 인원 감지
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FireInfo(),
                    SizedBox(width: 20),
                    FireDetect(),
                  ],
                ),
                const SizedBox(height: 40),
                const FireFinish(), // 화재 진화 완료
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
      title: const Text("Booriya"),
      automaticallyImplyLeading: false, // 뒤로가기 버튼 삭제
    );
  }
}
