String formatTime(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;

  final secondsText = seconds.toString().padLeft(2, '0');

  return '$minutes:$secondsText';
}
