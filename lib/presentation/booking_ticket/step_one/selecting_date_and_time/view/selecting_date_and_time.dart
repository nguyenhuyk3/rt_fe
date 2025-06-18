import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rt_mobile/core/constants/errors.dart';
import 'package:rt_mobile/core/utils/convetors/map.dart';
import 'package:rt_mobile/core/utils/convetors/string.dart';
import 'package:rt_mobile/presentation/booking_ticket/bloc/bloc.dart';
import 'package:rt_mobile/presentation/cubit/change_tab/change_tab.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_one/seats/bloc/bloc.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_one/selecting_date_and_time/bloc/bloc.dart';
import 'package:rt_mobile/presentation/splash/spash_view.dart';

class SelectingDateAndTimeView extends StatelessWidget {
  const SelectingDateAndTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChangeTabCubit<int>>(
          create: (_) => ChangeTabCubit<int>(initialState: 0),
        ),
        BlocProvider<ChangeTabCubit<String>>(
          create: (_) => ChangeTabCubit<String>(initialState: ''),
        ),
      ],
      child: BlocBuilder<SelectingDateAndTimeBloc, SelectingDateAndTimeState>(
        builder: (context, state) {
          if (state is SelectingDateAndTimeLoadSuccess) {
            return _SelectingDateAndTimeContainer(
              dates: List.generate(
                14,
                (index) => DateFormat(
                  'yyyy-MM-dd',
                ).format(DateTime.now().add(Duration(days: index + 1))),
              ),
              groupedShowtimes: groupShowtimes(showtimes: state.showtimes),
            );
          } else if (state is SelectingDateAndTimeLoading) {
            return SplashPage();
          } else {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'Máy chủ đã xảy ra lỗi',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class _SelectingDateAndTimeContainer extends StatelessWidget {
  // dates: will be provided 14 days from tomorrow
  final List<String> dates;
  final Map<String, List<String>> groupedShowtimes;

  const _SelectingDateAndTimeContainer({
    required this.dates,
    required this.groupedShowtimes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // dates
        SizedBox(
          height: 82,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final selectedIndex = context.watch<ChangeTabCubit<int>>().state;

              return _BuildDateButton(
                date: dates[index],
                isSelected: index == selectedIndex,
                onTap: () {
                  final times = groupedShowtimes[dates[index]];
                  final showtimeKey = times?.first ?? '';

                  context.read<ChangeTabCubit<int>>().changeTab(index);
                  context.read<ChangeTabCubit<String>>().changeTab(showtimeKey);

                  final showtimeIdStr = extractShowtimeId(input: showtimeKey);

                  context.read<SeatsBloc>().add(
                    showtimeIdStr.isNotEmpty
                        ? SeatsFetched(showtimeId: int.parse(showtimeIdStr))
                        : SeatsNoShowtimeSeats(message: NO_SHOWTIME_SEAT),
                  );
                },
              );
            },
          ),
        ),

        SizedBox(height: 16),

        // times
        BlocBuilder<ChangeTabCubit<int>, int>(
          builder: (context, selectedIndex) {
            final times = groupedShowtimes[dates[selectedIndex]] ?? [];

            return BlocBuilder<ChangeTabCubit<String>, String>(
              builder: (context, selectedTime) {
                // If time is not selected then auto select first element
                if (times.isNotEmpty && selectedTime.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<ChangeTabCubit<String>>().changeTab(times[0]);
                    context.read<BookingTicketBloc>().add(
                      BookingTicketChoseStartTime(
                        showDate: dates[selectedIndex],
                        startTime: extractStartTime(input: times[0]),
                        showtimeId: int.parse(
                          extractShowtimeId(input: times[0]),
                        ),
                      ),
                    );
                  });
                }

                return SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: times.length,
                    itemBuilder: (context, index) {
                      final time = times[index];

                      return _BuildTimeButton(
                        time: extractStartTime(input: time),
                        isSelected: time == selectedTime,
                        onTap: () {
                          context.read<ChangeTabCubit<String>>().changeTab(
                            time,
                          );
                          context.read<SeatsBloc>().add(
                            SeatsFetched(
                              showtimeId: int.parse(
                                extractShowtimeId(input: time),
                              ),
                            ),
                          );

                          context.read<BookingTicketBloc>().add(
                            BookingTicketChoseStartTime(
                              showDate: dates[selectedIndex],
                              startTime: extractStartTime(input: time),
                              showtimeId: int.parse(
                                extractShowtimeId(input: time),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _BuildDateButton extends StatelessWidget {
  final String date;
  final bool isSelected;
  final VoidCallback onTap;

  const _BuildDateButton({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.parse(date);
    final month = "T${parsedDate.month}";
    final day = DateFormat('dd').format(parsedDate);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        padding: const EdgeInsets.symmetric(vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amberAccent : Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              month,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Color(0xFF1E1E1E),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  day,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildTimeButton extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const _BuildTimeButton({
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          border: Border.all(
            color: isSelected ? Colors.amberAccent : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          time,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
