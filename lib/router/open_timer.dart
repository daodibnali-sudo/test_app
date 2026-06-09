import 'package:flutter/material.dart';
import 'package:test_app/features/timer/pages/timer_run_page.dart';

void openTimerRunPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const TimerRunPage()),
  );
}
