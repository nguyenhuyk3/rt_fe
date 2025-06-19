import 'package:intl/intl.dart';
import 'package:rt_mobile/data/models/showtime/seat.showtime.dart';

String extractStartTime({required String input}) {
  final parts = input.split('-');

  return parts.length > 1 ? parts[1] : '';
}

String extractShowtimeId({required String input}) {
  final parts = input.split('-');

  return parts.isNotEmpty ? parts[0] : '';
}

String extractSeatNumber({required List<SeatShowtime> seats}) {
  return seats.map((seat) => seat.seatNumber).join(', ');
}

String formatCurrency(double amount) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(amount)} VND';
}

String formatDuration(String input) {
  final hourMatch = RegExp(r'(\d+)h').firstMatch(input);
  final minuteMatch = RegExp(r'(\d+)m').firstMatch(input);

  final hours = hourMatch != null ? int.parse(hourMatch.group(1)!) : 0;
  final minutes = minuteMatch != null ? int.parse(minuteMatch.group(1)!) : 0;

  if (minutes == 0) {
    return '$hours giờ';
  } else {
    return '$hours giờ $minutes phút';
  }
}

String formatDate(String input) {
  final parts = input.split('-');

  if (parts.length != 3) {
    return input;
  }

  final year = parts[0];
  final day = parts[1];
  final month = parts[2];

  return '$day/$month/$year';
}

String formatTimeToText(String input) {
  final parts = input.split(':');
  
  if (parts.length != 2) {
    return input;
  }

  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);

  if (minute == 0) {
    return '$hour giờ';
  } else {
    return '$hour giờ $minute phút';
  }
}
