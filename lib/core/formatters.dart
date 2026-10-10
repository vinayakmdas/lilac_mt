import 'package:intl/intl.dart';

class Fmt {
  static final NumberFormat _number = NumberFormat('#,##0.00');

  /// 2548 -> "$ 2,548.00"
  static String money(double v, {String symbol = '\$'}) =>
      '$symbol ${_number.format(v)}';

  /// "Tue, 22 Feb 2026"
  static String fieldDate(DateTime d) => DateFormat('EEE, dd MMM yyyy').format(d);

  /// "10/12/26"
  static String shortDate(DateTime d) => DateFormat('dd/MM/yy').format(d);

  /// Today / Yesterday / Jan 30, 2022
  static String relativeDate(DateTime d) {
    final today = dateOnly(DateTime.now());
    final diff = today.difference(dateOnly(d)).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('MMM dd, yyyy').format(d);
  }

  static String greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 17) return 'Good afternoon,';
    return 'Good evening,';
  }
}

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
