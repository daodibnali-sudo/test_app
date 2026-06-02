import 'package:flutter/material.dart';
import 'package:test_app/shared/theme/app_colors.dart';

class TimerSetPage extends StatefulWidget {
  const TimerSetPage({super.key});

  @override
  State<TimerSetPage> createState() => _TimerSetPageState();
}

class _TimerSetPageState extends State<TimerSetPage> {
  int minutes = 3;
  int seconds = 0;

  void onPlus() {
    setState(() {
      if (minutes == 0) {
        seconds += 10;
      } else {
        seconds += 30;
      }

      if (seconds >= 60) {
        minutes++;
        seconds -= 60;
      }
    });
  }

  void onMinus() {
    setState(() {
      if (minutes == 0 && seconds == 0) {
        return;
      } else if (minutes == 0 || (minutes == 1 && seconds == 0)) {
        seconds -= 10;
      } else {
        seconds -= 30;
      }

      if (minutes > 0 && seconds < 0) {
        minutes--;
        seconds += 60;
      }

      if (minutes == 0 && seconds < 0) {
        seconds = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBg,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Timer Boxing app',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              'WORLDS NO.1 BOXING TIMER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                ),
              ),

              IconButton(
                onPressed: onMinus,
                icon: const Icon(Icons.remove),
                iconSize: 52,
                color: Colors.white,
                highlightColor: Colors.deepOrangeAccent,
              ),

              IconButton(
                onPressed: onPlus,
                icon: const Icon(Icons.add),
                iconSize: 52,
                color: Colors.white,
                highlightColor: Colors.greenAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}