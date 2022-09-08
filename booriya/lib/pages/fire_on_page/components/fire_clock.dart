import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerPage extends StatefulWidget {
  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  @override
  void initState() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    _stopWatchTimer.setPresetTime(mSec: 1234);
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
        initialData: 0,
        builder: (context, snap) {
          final value = snap.data!;
          final displayTime = StopWatchTimer.getDisplayTime(value);
          return SizedBox(
            height: 30,
            child: Text(
              displayTime,
              style: TextStyle(
                color: Colors.deepOrangeAccent,
                fontSize: 30,
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
