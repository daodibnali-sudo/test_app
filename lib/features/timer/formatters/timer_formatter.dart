String formatTime(int totalMs) {
  final minutes = totalMs ~/ 60000;
  final seconds = totalMs % 60000 ~/ 1000;

  final secondsText = seconds.toString().padLeft(2, '0');

  return '$minutes:$secondsText';
}
