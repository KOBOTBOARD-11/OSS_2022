import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FireOff extends StatefulWidget {
  const FireOff({Key? key}) : super(key: key);

  @override
  State<FireOff> createState() => _FireOffState();
}

class _FireOffState extends State<FireOff> {
  var _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //알림을 눌렀을때 어떤 행동을 할지 정해주는 부분
  Future onSelectNotification(String payload) async {
    print("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('우왕 잘됩니다!!!!우와아아아아아아앙!!!'),
        content: Text('Payload: $payload'),
      ),
    );
  }

  Future<void> _showNotification() async {
    print("dkdkd");
    var android = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high);

    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
      0,
      '단일 Notification',
      '단일 Notification 내용',
      detail,
      payload: 'Hello Flutter',
    );
    print('dfdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("화재 발생 정보"),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            _showNotification();
            // Navigator.pushNamed(context, "/on");
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
