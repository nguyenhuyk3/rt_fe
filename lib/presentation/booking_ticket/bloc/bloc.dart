import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/models/film/film.product.dart';
import 'package:rt_mobile/data/models/product/cart.dart';

import 'package:rt_mobile/data/models/product/fab.product.dart';
import 'package:rt_mobile/data/models/showtime/seat.showtime.dart';
import 'package:rt_mobile/data/repositories/film.dart';
import 'package:rt_mobile/data/repositories/order.dart';
import 'package:rt_mobile/presentation/booking_ticket/bloc/event.sub.dart';

part 'event.dart';
part 'state.dart';

class BookingTicketBloc extends Bloc<BookingTicketEvent, BookingTicketState> {
  final FilmRepository filmRepository;
  final OrderRepository orderRepository;

  BookingTicketBloc({
    required this.filmRepository,
    required this.orderRepository,
  }) : super(BookingTicketState()) {
    on<BookingTicketGetFilm>(_onGetFilm);
    on<BookingTicketAddSeatToOrder>(_onAddSeat);
    on<BookingTicketRemoveSeatFromOrder>(_onRemoveSeat);
    on<BookingTicketAddFABToOrder>(_onAddFAB);
    on<BookingTicketRemoveFABFromOrder>(_onRemoveFAB);
    on<BookingTicketClearOrder>(_onClearOrder);
    on<BookingTicketChoseStartTime>(_onChoseStartTime);
    on<BookingTicketCreateOrder>(_onCreateOrder);
    on<BookingTicketChangeIsLogin>(_onChangeIsLogin);
  }

  void _onAddSeat(
    BookingTicketAddSeatToOrder event,
    Emitter<BookingTicketState> emit,
  ) {
    final updatedSeats = List<SeatShowtime>.from(state.seats);

    if (!updatedSeats.contains(event.seat)) {
      updatedSeats.add(event.seat);
    }

    final total = _calculateTotal(
      updatedSeats,
      state.fABs,
      isCoupled: event.isCoupled,
    );

    emit(state.copyWith(seats: updatedSeats, totalAmount: total));
  }

  void _onRemoveSeat(
    BookingTicketRemoveSeatFromOrder event,
    Emitter<BookingTicketState> emit,
  ) {
    final updatedSeats =
        state.seats.where((s) => s.id != event.seat.id).toList();
    final total = _calculateTotal(updatedSeats, state.fABs);

    emit(state.copyWith(seats: updatedSeats, totalAmount: total));
  }

  void _onAddFAB(
    BookingTicketAddFABToOrder event,
    Emitter<BookingTicketState> emit,
  ) {
    final updatedFABs = List<CartItem>.from(state.fABs);

    // Find out if the product is already in the cart
    final existingIndex = updatedFABs.indexWhere(
      (item) => item.fABProduct.id == event.fAB.id,
    );

    if (existingIndex != -1) {
      // If already exists, increase quantity
      final existingItem = updatedFABs[existingIndex];
      updatedFABs[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // If not, add new
      updatedFABs.add(CartItem(fABProduct: event.fAB, quantity: 1));
    }

    final total = _calculateTotal(state.seats, updatedFABs);

    emit(state.copyWith(fABs: updatedFABs, totalAmount: total));
  }

  void _onRemoveFAB(
    BookingTicketRemoveFABFromOrder event,
    Emitter<BookingTicketState> emit,
  ) {
    final updatedFABs = List<CartItem>.from(state.fABs);

    final existingIndex = updatedFABs.indexWhere(
      (item) => item.fABProduct.id == event.fAB.fABProduct.id,
    );

    if (existingIndex != -1) {
      final existingItem = updatedFABs[existingIndex];

      if (existingItem.quantity > 1) {
        // If quantity > 1, decrease quantity
        updatedFABs[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity - 1,
        );
      } else {
        // If quantity = 1, delete from cart
        updatedFABs.removeAt(existingIndex);
      }
    }

    final total = _calculateTotal(state.seats, updatedFABs);

    emit(state.copyWith(fABs: updatedFABs, totalAmount: total));
  }

  double _calculateTotal(
    List<SeatShowtime> seats,
    List<CartItem> fabs, {
    bool isCoupled = false,
  }) {
    final seatTotal = seats.fold<double>(0.0, (sum, seat) {
      final price = seat.price.toDouble();

      return sum +
          (seat.seatType == 'coupled' || isCoupled ? price * 2 : price);
    });

    final fabTotal = fabs.fold<double>(
      0.0,
      (sum, cartItem) => sum + (cartItem.fABProduct.price * cartItem.quantity),
    );

    return seatTotal + fabTotal;
  }

  void _onClearOrder(
    BookingTicketClearOrder event,
    Emitter<BookingTicketState> emit,
  ) {
    emit(state.copyWith(seats: [], fABs: [], totalAmount: 0.0));
  }

  FutureOr<void> _onGetFilm(
    BookingTicketGetFilm event,
    Emitter<BookingTicketState> emit,
  ) async {
    try {
      final film = await filmRepository.getFilmById(filmId: event.filmId);

      emit(state.copyWith(film: film));
    } catch (e) {
      emit(state.copyWith(messageError: e.toString()));
    }
  }

  FutureOr<void> _onChoseStartTime(
    BookingTicketChoseStartTime event,
    Emitter<BookingTicketState> emit,
  ) {
    emit(
      state.copyWith(
        showDate: event.showDate,
        startTime: event.startTime,
        showtimeId: event.showtimeId,
      ),
    );
  }

  FutureOr<void> _onCreateOrder(
    BookingTicketCreateOrder event,
    Emitter<BookingTicketState> emit,
  ) async {
    try {
      final accessToken = await storage.read(ACCESS_TOKEN);

      if (accessToken == null || accessToken.isEmpty) {
        emit(state.copyWith(isLogin: false));

        return;
      }

      final orderId = await orderRepository.createOrder(
        request: event.toJson(),
      );

      await Future.delayed(Duration(seconds: 1));

      emit(state.copyWith(orderId: orderId));
    } catch (e) {
      if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        emit(state.copyWith(isLogin: false));

        return;
      }
      emit(state.copyWith(messageError: e.toString()));
    }
  }

  FutureOr<void> _onChangeIsLogin(
    BookingTicketChangeIsLogin event,
    Emitter<BookingTicketState> emit,
  ) {
    emit(state.copyWith(isLogin: event.isLogin));
  }
}
