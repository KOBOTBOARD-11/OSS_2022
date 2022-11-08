import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Colors.dart';
import '../../../styles.dart';
import 'detect_info_datalist.dart';
import 'fire_detect_page_detail.dart';

class FireDetectPage extends StatefulWidget {
  const FireDetectPage({Key? key}) : super(key: key);

  @override
  State<FireDetectPage> createState() => _FireDetectPageState();
}

class _FireDetectPageState extends State<FireDetectPage> {
  @override
  Widget build(BuildContext context) {
    var snapshot =
        FirebaseFirestore.instance.collection('fire situation_C').snapshots();
    // firebase에 있는 fire situation_C 컬렉션에 담긴 내용이 변화할때마다 해당 변화 snapshot을 가져온다.
    return Scaffold(
      appBar: AppBar(
        title: const Text("인원 감지 내역"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: snapshot,
          builder: (context, snapshot) {
            if (snapshot.data?.size == 0) {
              // snapshot 데이터가 비어있으면
              return SizedBox(
                // 즉, 컬렉션에 아무것도 없으면 No Data를 출력한다.
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
              // snapshot 데이터를 가져오고 있을 때
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: backgroundColor(),
                child: Center(
                  child: CircularProgressIndicator(color: appBarColor()),
                ),
              );
            } else {
              // snapshot에 데이터가 담겨 있을 때 즉, 인원감지가 되었을 때
              if (detectInfo.isEmpty ||
                  snapshot.data?.docs.last['detected_Time'] !=
                      detectInfo.last['detected_Time']) {
                // detectInfo가 비어있거나 또는
                // 해당 데이터에서 인원이 감지된 시간과 detectInfo에 전에 저장된 최근 데이터의 인원이 감지된 시간이 다르면
                detectInfo.add(snapshot.data?.docs.last.data());
                // detectInfo에 해당 Snapshot의 Data를 넣는다.
              }
              return Align(
                // detectInfo에 들어간 데이터만큼 detect_page에 해당 데이터들을 넣는다.
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

  // detectInfo에 담긴 데이터들을 클릭하면 detail 페이지로 넘어가는 버튼으로 구성해주는 위젯
  Widget _buildDetectButton(String imageUrl, String cctvName, String date,
      String count, BuildContext context) {
    print(imageUrl);
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
                          date: date.substring(4, 27),
                          count: count),
                    );
                  },
                  child: Text(
                    textAlign: TextAlign.center,
                    "$cctvName\n${date.substring(4, 27)}",
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
