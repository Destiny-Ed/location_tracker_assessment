import 'package:intl/intl.dart';

String getDateLabel(DateTime date) {
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  final logDate = DateTime(date.year, date.month, date.day);

  if (logDate == today) return "Today";
  if (logDate == yesterday) return "Yesterday";

  return DateFormat('dd MMM yyyy').format(date);
}
