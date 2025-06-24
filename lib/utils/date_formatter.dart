import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    try {
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      try {
        return DateFormat('dd MMMM yyyy', 'en_US').format(date);
      } catch (e2) {
        print('❌ Error formatting date with all locales: $e2');
        return _formatDateManual(date);
      }
    }
  }

  static String formatDateShort(DateTime date) {
    try {
      return DateFormat('dd MMM yyyy', 'id_ID').format(date);
    } catch (e) {
      try {
        return DateFormat('dd MMM yyyy', 'en_US').format(date);
      } catch (e2) {
        return _formatDateShortManual(date);
      }
    }
  }

  static String formatTime(DateTime date) {
    try {
      return DateFormat('HH:mm', 'id_ID').format(date);
    } catch (e) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  static String formatDateTime(DateTime date) {
    try {
      return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(date);
    } catch (e) {
      return '${formatDate(date)}, ${formatTime(date)}';
    }
  }

  static String _formatDateManual(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = _getMonthNameFull(date.month);
    final year = date.year.toString();
    return '$day $month $year';
  }

  static String _formatDateShortManual(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = _getMonthNameShort(date.month);
    final year = date.year.toString();
    return '$day $month $year';
  }

  static String _getMonthNameFull(int month) {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month];
  }

  static String _getMonthNameShort(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return months[month];
  }

  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final difference = targetDate.difference(today).inDays;

    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == 1) {
      return 'Besok';
    } else if (difference == -1) {
      return 'Kemarin';
    } else if (difference > 0) {
      return '$difference hari lagi';
    } else {
      final daysPast = difference.abs();
      return '$daysPast hari yang lalu';
    }
  }

  static String getDuration(DateTime start, DateTime end) {
    final difference = end.difference(start).inDays + 1;
    if (difference == 1) {
      return '1 hari';
    } else if (difference < 7) {
      return '$difference hari';
    } else if (difference < 30) {
      final weeks = (difference / 7).round();
      return '$weeks minggu';
    } else {
      final months = (difference / 30).round();
      return '$months bulan';
    }
  }
}
