part of 'bloc.dart';

sealed class BookingTicketEvent extends Equatable {
  const BookingTicketEvent();

  @override
  List<Object> get props => [];
}

class BookingTicketGetFilm extends BookingTicketEvent {
  final int filmId;

  const BookingTicketGetFilm({required this.filmId});

  @override
  List<Object> get props => [filmId];
}

class BookingTicketAddSeatToOrder extends BookingTicketEvent {
  final SeatShowtime seat;
  final bool isCoupled;

  const BookingTicketAddSeatToOrder({
    required this.seat,
    required this.isCoupled,
  });

  @override
  List<Object> get props => [seat, isCoupled];
}

class BookingTicketRemoveSeatFromOrder extends BookingTicketEvent {
  final SeatShowtime seat;
  final bool isCoupled;

  const BookingTicketRemoveSeatFromOrder({
    required this.seat,
    required this.isCoupled,
  });

  @override
  List<Object> get props => [seat, isCoupled];
}

class BookingTicketAddFABToOrder extends BookingTicketEvent {
  final FABProduct fAB;

  const BookingTicketAddFABToOrder({required this.fAB});

  @override
  List<Object> get props => [fAB];
}

class BookingTicketRemoveFABFromOrder extends BookingTicketEvent {
  final CartItem fAB;

  const BookingTicketRemoveFABFromOrder({required this.fAB});

  @override
  List<Object> get props => [fAB];
}

class BookingTicketClearOrder extends BookingTicketEvent {}

class BookingTicketChoseStartTime extends BookingTicketEvent {
  final String showDate;
  final String startTime;
  final int showtimeId;

  const BookingTicketChoseStartTime({
    required this.showDate,
    required this.startTime,
    required this.showtimeId,
  });

  @override
  List<Object> get props => [startTime];
}

class BookingTicketCreateOrder extends BookingTicketEvent {
  final int showtimeId;
  final String showDate;
  final List<Seat> seats;
  final List<FAB> fABs;

  const BookingTicketCreateOrder({
    required this.showtimeId,
    required this.showDate,
    required this.seats,
    required this.fABs,
  });

  Map<String, dynamic> toJson() {
    return {
      'showtime_id': showtimeId,
      'show_date': showDate,
      'seats': seats.map((seat) => seat.toJson()).toList(),
      'fabs': fABs.map((fab) => fab.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [showtimeId, showDate, seats, fABs];
}
