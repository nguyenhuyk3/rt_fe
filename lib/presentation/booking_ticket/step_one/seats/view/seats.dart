import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rt_mobile/core/constants/errors.dart';
import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/core/utils/convetors/color.dart';
import 'package:rt_mobile/data/models/showtime/seat.showtime.dart';
import 'package:rt_mobile/presentation/booking_ticket/bloc/bloc.dart';
import 'package:rt_mobile/presentation/booking_ticket/constants.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_one/seats/bloc/bloc.dart';
import 'package:rt_mobile/presentation/splash/spash_view.dart';

class SeatsView extends StatelessWidget {
  const SeatsView({super.key});

  final double seatSize = 36;
  final double seatSpacing = 3;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeatsBloc, SeatsState>(
      builder: (context, state) {
        final double screenHeight = MediaQuery.of(context).size.height;

        if (state is SeatsLoading) {
          return SplashPageWithHeight(
            height: totalSeatAndColorAnnotationSize * screenHeight,
          );
        } else if (state is SeatsLoadSuccess) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // seats
              SizedBox(
                width: double.infinity,
                height: screenHeight * seatsSize,
                child: SingleChildScrollView(
                  child: Center(
                    child: _SeatRows(
                      seats: state.seats,
                      selectedSeatIds: state.selectedSeatIds,
                      seatSize: seatSize,
                      seatSpacing: seatSpacing,
                      getSeatColor: getSeatColor,
                    ),
                  ),
                ),
              ),

              // Color annotation
              SizedBox(
                height: screenHeight * colorAnnotation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _SeatLegend(
                        color: const Color(0xFF1E1E1E),
                        label: "Có sẵn",
                      ),
                      _SeatLegend(color: Colors.grey, label: "Đã được đặt"),
                      _SeatLegend(color: Colors.amber, label: "Đã chọn"),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (state is SeatsError) {
          switch (state.message) {
            case NO_SHOWTIME_SEAT:
              return SizedBox(
                height: totalSeatAndColorAnnotationSize * screenHeight,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.event_busy, size: 64, color: Colors.white70),

                      const SizedBox(height: 16),

                      const Text(
                        NO_SHOWTIME_SEAT,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            default:
              return SizedBox(
                height: totalSeatAndColorAnnotationSize * screenHeight,
                child: const Center(
                  child: Text(
                    NO_SHOWTIME_SEAT,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
          }
        } else {
          return SizedBox(
            height: totalSeatAndColorAnnotationSize * screenHeight,
            child: const Center(
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
    );
  }
}

class _SeatRows extends StatelessWidget {
  final List<SeatShowtime> seats;
  final Set<int> selectedSeatIds;
  final double seatSize;
  final double seatSpacing;
  final Color Function(String) getSeatColor;

  const _SeatRows({
    required this.seats,
    required this.selectedSeatIds,
    required this.seatSize,
    required this.seatSpacing,
    required this.getSeatColor,
  });

  @override
  Widget build(BuildContext context) {
    /*
    In Flutter, Wrap is a layout widget that automatically arranges its children 
    horizontally or vertically and "wraps" them to the next line (or column) 
    when there's not enough space.

    📦 How it works:
        If there isn't enough space in the main axis (default is horizontal) 
        to fit all the children in one line, Wrap will automatically move 
        the remaining widgets to the next line (or next column if the direction is vertical).
    
        This behavior is different from Row and Column, which do not automatically 
        wrap when space runs out.
    */

    return Wrap(
      // spacing between widgets horizontally
      spacing: seatSpacing,
      // spacing between rows (or columns if vertical)
      runSpacing: seatSpacing,
      children: _buildSeatRows(context),
    );
  }

  List<Widget> _buildSeatRows(BuildContext context) {
    final List<Widget> rows = [];
    final pairedIds = <int>{};

    List<Widget> currentRow = [];
    // 1 for standard, 2 for coupled
    double currentSlots = 0;

    for (final seat in seats) {
      if (pairedIds.contains(seat.seatId)) {
        continue;
      }

      if (seat.seatType == 'coupled' && seat.seatId % 2 == 1) {
        // Coupled seat take up 2 slot
        if (currentSlots + 2 > 10) {
          rows.add(
            Row(
              mainAxisAlignment:
                  // Center the seats in the row
                  MainAxisAlignment.center,
              children: currentRow,
            ),
          );

          currentRow = [];
          currentSlots = 0;
        }

        final pair = seats.firstWhere(
          (s) => s.seatId == seat.seatId + 1,
          orElse: () => seat,
        );

        pairedIds.add(pair.seatId);

        // coupled
        currentRow.add(
          GestureDetector(
            onTap: () {
              if (seat.status == 'available') {
                context.read<SeatsBloc>().add(SeatsToggled(seat.seatId));
                context.read<SeatsBloc>().add(SeatsToggled(pair.seatId));

                final isSelected = selectedSeatIds.contains(seat.seatId);

                if (isSelected) {
                  logger.i(seat.seatId);

                  context.read<BookingTicketBloc>().add(
                    BookingTicketRemoveSeatFromOrder(
                      seat: seat,
                      isCoupled: true,
                    ),
                  );
                  context.read<BookingTicketBloc>().add(
                    BookingTicketRemoveSeatFromOrder(
                      seat: seat,
                      isCoupled: true,
                    ),
                  );
                } else {
                  context.read<BookingTicketBloc>().add(
                    BookingTicketAddSeatToOrder(seat: seat, isCoupled: true),
                  );
                  context.read<BookingTicketBloc>().add(
                    BookingTicketAddSeatToOrder(seat: pair, isCoupled: true),
                  );
                }
              }
            },
            child: Container(
              width: seatSize * 2 + seatSpacing,
              height: seatSize,
              margin: EdgeInsets.only(right: seatSpacing),
              decoration: BoxDecoration(
                color:
                    selectedSeatIds.contains(seat.seatId)
                        ? Colors.amber
                        : getSeatColor(seat.status),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                '${seat.seatNumber}  -  ${pair.seatNumber}',
                style: TextStyle(
                  color:
                      selectedSeatIds.contains(seat.seatId)
                          ? Colors.black
                          : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );

        currentSlots += 2;
      } else if (seat.seatType != 'coupled') {
        // Regular seats take up 1 slot
        if (currentSlots + 1 > 10) {
          rows.add(
            Row(
              mainAxisAlignment:
                  // Center the seats in the row
                  MainAxisAlignment.center,
              children: currentRow,
            ),
          );

          currentRow = [];
          currentSlots = 0;
        }

        // non-coupled
        currentRow.add(
          GestureDetector(
            onTap: () {
              if (seat.status == 'available') {
                context.read<SeatsBloc>().add(SeatsToggled(seat.seatId));

                final isSelected = selectedSeatIds.contains(seat.seatId);

                if (isSelected) {
                  context.read<BookingTicketBloc>().add(
                    BookingTicketRemoveSeatFromOrder(
                      seat: seat,
                      isCoupled: false,
                    ),
                  );
                } else {
                  context.read<BookingTicketBloc>().add(
                    BookingTicketAddSeatToOrder(seat: seat, isCoupled: false),
                  );
                }
              }
            },
            child: Container(
              width: seatSize,
              height: seatSize,
              margin: EdgeInsets.only(right: seatSpacing),
              decoration: BoxDecoration(
                color:
                    selectedSeatIds.contains(seat.seatId)
                        ? Colors.amber
                        : getSeatColor(seat.status),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(
                seat.seatNumber,
                style: TextStyle(
                  color:
                      selectedSeatIds.contains(seat.seatId)
                          ? Colors.black
                          : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );

        currentSlots += 1;
      }
    }

    // Add remaining rows
    if (currentRow.isNotEmpty) {
      rows.add(
        Row(
          mainAxisAlignment:
              // Center the seats in the row
              MainAxisAlignment.center,
          children: currentRow,
        ),
      );
    }

    return rows;
  }
}

class _SeatLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _SeatLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),

        const SizedBox(width: 6),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
