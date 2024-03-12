class DataUtils {
  static double decimalPointFix(double value, int fractionDigits) {
    return double.parse(value.toStringAsFixed(fractionDigits));
  }

  static String secToMMSS(int second) {
    int sec = second;
    final mm = (sec ~/ 60).toString().padLeft(2, '0');
    sec %= 60;
    final ss = sec.toString().padLeft(2, '0');

    return '$mm:$ss';
  }

  static String secToHHMMSS(int second) {
    int sec = second;
    final hh = (sec ~/ 3600).toString().padLeft(2, '0');
    sec %= 3600;
    final mm = (sec ~/ 60).toString().padLeft(2, '0');
    sec %= 60;
    final ss = sec.toString().padLeft(2, '0');

    return '$hh:$mm:$ss';
  }
}
