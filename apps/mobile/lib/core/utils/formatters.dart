import 'package:intl/intl.dart';

/// "18 Eylül 2026", matching the web's `toLocaleDateString("tr-TR", …)`.
/// Needs `initializeDateFormatting('tr')` (done in `main`).
String formatDate(DateTime date) =>
    DateFormat('d MMMM y', 'tr').format(date.toLocal());

/// "1 Eylül – 30 Ekim 2026" (year shown once when both dates share it).
String formatDateRange(DateTime start, DateTime end) {
  final s = start.toLocal();
  final e = end.toLocal();
  final startPattern = s.year == e.year ? 'd MMMM' : 'd MMMM y';
  return '${DateFormat(startPattern, 'tr').format(s)} – ${formatDate(e)}';
}
