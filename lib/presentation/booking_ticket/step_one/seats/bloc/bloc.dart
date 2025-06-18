import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_mobile/core/constants/errors.dart';
import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/models/showtime/seat.showtime.dart';

import 'package:rt_mobile/data/repositories/showtime.dart';

part 'event.dart';
part 'state.dart';

class SeatsBloc extends Bloc<SeatsEvent, SeatsState> {
  final ShowtimeRepository showtimeRepository;

  SeatsBloc({required this.showtimeRepository}) : super(SeatsInitial()) {
    on<SeatsFetched>(_onSeatsFetched);
    on<SeatsRefreshed>(_onSeatsRefreshed);
    on<SeatsToggled>(_onSeatToggled);
    on<SeatsNoShowtimeSeats>(_onSeatsNoShowtimeSeats);
  }

  FutureOr<void> _onSeatsFetched(
    SeatsFetched event,
    Emitter<SeatsState> emit,
  ) async {
    emit(SeatsLoading());

    try {
      logger.e(event.filmId);

      final seats =
          (event.filmId != -1 && event.showtimeId == -1)
              ? await showtimeRepository
                  .getAllShowtimesSeatsByFilmIdFromEarliestTomorrow(
                    filmId: event.filmId,
                  )
              : await showtimeRepository.getAllShowtimeSeatsByShowtimeId(
                showtimeId: event.showtimeId,
              );

      emit(SeatsLoadSuccess(seats: seats));
    } catch (e) {
      emit(SeatsError(message: e.toString()));
    }
  }

  FutureOr<void> _onSeatsRefreshed(
    SeatsRefreshed event,
    Emitter<SeatsState> emit,
  ) {}

  FutureOr<void> _onSeatToggled(SeatsToggled event, Emitter<SeatsState> emit) {
    if (state is SeatsLoadSuccess) {
      final currentState = state as SeatsLoadSuccess;
      final seatsSelected = Set<int>.from(currentState.selectedSeatIds);

      if (seatsSelected.contains(event.seatId)) {
        seatsSelected.remove(event.seatId);
      } else {
        seatsSelected.add(event.seatId);
      }

      emit(
        SeatsLoadSuccess(
          seats: currentState.seats,
          selectedSeatIds: seatsSelected,
        ),
      );
    }
  }

  FutureOr<void> _onSeatsNoShowtimeSeats(
    SeatsNoShowtimeSeats event,
    Emitter<SeatsState> emit,
  ) {
    if (event.message == NO_SHOWTIME_SEAT) {
      emit(SeatsError(message: NO_SHOWTIME_SEAT));
    }
  }
}
