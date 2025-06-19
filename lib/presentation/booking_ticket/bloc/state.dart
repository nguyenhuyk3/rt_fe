part of 'bloc.dart';

class BookingTicketState extends Equatable {
  final int showtimeId;
  final FilmProduct film;
  final List<CartItem> fABs;
  final List<SeatShowtime> seats;
  final String showDate;
  final String startTime;
  final double totalAmount;
  final int orderId;
  final bool isLogin;
  final String messageError;

  BookingTicketState({
    this.showtimeId = -1,
    FilmProduct? film,
    this.fABs = const [],
    this.seats = const [],
    this.showDate = '',
    this.startTime = '',
    this.totalAmount = 0.0,
    this.orderId = -1,
    this.isLogin = true,
    this.messageError = '',
  }) : film = film ?? FilmProduct.empty();

  BookingTicketState copyWith({
    int? showtimeId,
    FilmProduct? film,
    List<CartItem>? fABs,
    List<SeatShowtime>? seats,
    String? showDate,
    String? startTime,
    double? totalAmount,
    int? orderId,
    bool? isLogin,
    String? messageError,
  }) {
    return BookingTicketState(
      showtimeId: showtimeId ?? this.showtimeId,
      film: film ?? this.film,
      fABs: fABs ?? this.fABs,
      seats: seats ?? this.seats,
      showDate: showDate ?? this.showDate,
      startTime: startTime ?? this.startTime,
      totalAmount: totalAmount ?? this.totalAmount,
      orderId: orderId ?? this.orderId,
      isLogin: isLogin ?? this.isLogin,
      messageError: messageError ?? this.messageError,
    );
  }

  @override
  List<Object?> get props => [
    film,
    fABs,
    seats,
    totalAmount,
    orderId,
    isLogin,
    messageError,
  ];
}
