import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/models/film/film.showtime.dart';
import 'package:rt_mobile/data/repositories/film.dart';

part 'event.dart';
part 'state.dart';

class FilmsBloc extends Bloc<FilmsEvent, FilmsState> {
  final FilmRepository filmRepository;

  FilmsBloc({required this.filmRepository}) : super(FilmsInitial()) {
    on<FilmsFetched>(_onFilmsFetched);
    on<FilmsRefreshed>(_onFilmsRefreshed);
  }

  FutureOr<void> _onFilmsFetched(
    FilmsFetched event,
    Emitter<FilmsState> emit,
  ) async {
    emit(FilmsLoading());

    await storage.delete(ACCESS_TOKEN);

    try {
      final films = await filmRepository.getAllFilmsCurrentlyShowing();

      emit(FilmsLoadSuccess(films: films));
    } catch (e) {
      emit(FilmsLoadFailed(message: e.toString()));
    }
  }

  FutureOr<void> _onFilmsRefreshed(
    FilmsRefreshed event,
    Emitter<FilmsState> emit,
  ) {}
}
