import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rt_mobile/data/repositories/fab_repository.dart';
import 'package:rt_mobile/data/repositories/film.dart';
import 'package:rt_mobile/data/repositories/order.dart';
import 'package:rt_mobile/data/repositories/showtime.dart';
import 'package:rt_mobile/presentation/booking_ticket/bloc/bloc.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_one/seats/bloc/bloc.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_one/seats/view/seats.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_one/seats/view/selected_seats_summary.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_one/selecting_date_and_time/bloc/bloc.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_one/selecting_date_and_time/view/selecting_date_and_time.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_two/selecting_fab/bloc/bloc.dart';
import 'package:rt_mobile/presentation/cubit/change_tab/change_tab.dart';
import 'package:rt_mobile/presentation/film_detail/available_cinema/view/available_cinema.dart';
import 'package:rt_mobile/presentation/film_detail/film_information/bloc/bloc.dart';

class StepOneScreen extends StatelessWidget {
  const StepOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final bloc = SelectingDateAndTimeBloc(
              showtimeRepository: RepositoryProvider.of<ShowtimeRepository>(
                context,
              ),
            );

            bloc.add(
              SelectingDateAndTimeFetched(
                filmId:
                    (context.read<FilmInformationBloc>().state
                            as FilmInformationLoadSuccess)
                        .film
                        .id,
                cinemaId:
                    context
                        .read<ChangeTabCubit<ChoseCinemaState>>()
                        .state
                        .selectedCinemaId,
              ),
            );

            return bloc;
          },
        ),
        BlocProvider(
          create: (_) {
            final bloc = SeatsBloc(
              showtimeRepository: RepositoryProvider.of<ShowtimeRepository>(
                context,
              ),
            );
            final filmId =
                (context.read<FilmInformationBloc>().state
                        as FilmInformationLoadSuccess)
                    .film
                    .id;

            bloc.add(SeatsFetched(filmId: filmId));

            return bloc;
          },
        ),
        BlocProvider(
          create:
              (_) => SelectingFABBloc(
                fABRepository: RepositoryProvider.of<FABRepository>(context),
              )..add(SelectingFABLoadFoodItems()),
        ),
        BlocProvider(
          create:
              (_) => BookingTicketBloc(
                filmRepository: RepositoryProvider.of<FilmRepository>(context),
                orderRepository: RepositoryProvider.of<OrderRepository>(
                  context,
                ),
              )..add(
                BookingTicketGetFilm(
                  filmId:
                      (context.read<FilmInformationBloc>().state
                              as FilmInformationLoadSuccess)
                          .film
                          .id,
                ),
              ),
        ),
      ],
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 32),

            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const Center(
                  child: Text(
                    "Đặt ghế",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            SeatsView(),

            SizedBox(height: 18),

            Text(
              "Chọn ngày và giờ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 18),

            SelectingDateAndTimeView(),

            SizedBox(height: 12),

            SelectedSeatSummaryView(),
          ],
        ),
      ),
    );
  }
}
