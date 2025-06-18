import 'package:rt_mobile/presentation/booking_ticket/bloc/event.sub.dart';

class SeatShowtime {
  final int id;
  final int showtimeId;
  final int seatId;
  final String seatType;
  final String seatNumber;
  final int price;
  final String status;
  final String bookedBy;
  final DateTime createdAt;
  final DateTime? bookedAt;

  SeatShowtime({
    required this.id,
    required this.showtimeId,
    required this.seatId,
    required this.seatType,
    required this.seatNumber,
    required this.price,
    required this.status,
    required this.bookedBy,
    required this.createdAt,
    this.bookedAt,
  });

  factory SeatShowtime.fromJson(Map<String, dynamic> json) {
    return SeatShowtime(
      id: json['id'],
      showtimeId: json['showtime_id'],
      seatId: json['seat_id'],
      seatType: json['seat_type'],
      seatNumber: json['seat_number'],
      price: json['price'],
      status: json['status'],
      bookedBy: json['booked_by'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      bookedAt:
          json['booked_at'] != null
              ? DateTime.tryParse(json['booked_at'])
              : null,
    );
  }

  Seat toSeat() {
    return Seat(seatId: id);
  }
}
