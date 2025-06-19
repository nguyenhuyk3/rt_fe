import 'package:flutter/material.dart';

import 'package:barcode_widget/barcode_widget.dart';

import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/core/utils/convetors/string.dart';
import 'package:rt_mobile/data/models/others.dart';
import 'package:rt_mobile/presentation/home/home_screen.dart';

// ===== MAIN SCREEN =====
class TicketInformationScreen extends StatelessWidget {
  final TicketInformation ticketInformation;

  const TicketInformationScreen({super.key, required this.ticketInformation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Vé của tôi',
          style: TextStyle(
            color: Colors.white,
            fontSize: HEADER_SIZE,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _TicketInformationContainer(
                    ticketInformation: ticketInformation,
                  ),

                  SizedBox(height: 12),

                  _ContinuationButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketInformationContainer extends StatelessWidget {
  final TicketInformation ticketInformation;

  const _TicketInformationContainer({required this.ticketInformation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _MovieInfoSection(
            filmTitle: ticketInformation.title,
            imageUrl: ticketInformation.filmPoster,
            filmDuration: formatDuration(ticketInformation.duration),
            genres: ticketInformation.genres,
            showDate: ticketInformation.showDate,
            startTime: ticketInformation.startTime,
          ),

          _SeatAndFabSection(
            roomName: ticketInformation.roomName,
            seats: ticketInformation.seats,
            fabInfoList: ticketInformation.fABs,
          ),

          const SizedBox(height: MIN_HEIGHT_SIZED_BOX),

          const Divider(height: 1, color: Colors.black, thickness: 0.6),

          _PriceSection(total: ticketInformation.totalAmount.toString()),

          _LocationSection(
            city: ticketInformation.city,
            cinemaLocation: ticketInformation.location,
          ),

          const _QRInstructionSection(),

          const SizedBox(height: MIN_HEIGHT_SIZED_BOX),

          _DottedLine(),

          _BarcodeSection(orderId: ticketInformation.orderId),
        ],
      ),
    );
  }
}

class _DottedLine extends StatelessWidget {
  const _DottedLine();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 20),
      painter: DottedLinePainter(),
    );
  }
}

// ===== MOVIE INFO SECTION =====
class _MovieInfoSection extends StatelessWidget {
  final String filmTitle;
  final String imageUrl;
  final String filmDuration;
  final String genres;
  final String showDate;
  final String startTime;

  const _MovieInfoSection({
    required this.filmTitle,
    required this.imageUrl,
    required this.filmDuration,
    required this.genres,
    required this.showDate,
    required this.startTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          _buildMoviePoster(),

          const SizedBox(width: 16),

          _buildMovieDetails(),
        ],
      ),
    );
  }

  Widget _buildMoviePoster() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 100,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 100,
            height: 120,
            color: Colors.black,
            child: const Icon(Icons.movie),
          );
        },
      ),
    );
  }

  Widget _buildMovieDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            filmTitle,
            style: TextStyle(
              color: Colors.black,
              fontSize: TITLE_H1,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),

          const SizedBox(height: MIN_HEIGHT_SIZED_BOX),

          _buildDetailRow(Icons.access_time, filmDuration),

          const SizedBox(height: MIN_HEIGHT_SIZED_BOX),

          _buildDetailRow(Icons.local_movies, genres),

          const SizedBox(height: MIN_HEIGHT_SIZED_BOX),

          _buildDetailRow(
            Icons.access_time_outlined,
            "${formatDate(showDate)} • ${formatTimeToText(startTime)}",
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: TITLE_H2, color: Colors.black),

        const SizedBox(width: 4),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: TITLE_H2,
              fontWeight: FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

// ===== SEAT AND FAB SECTION =====
class _SeatAndFabSection extends StatelessWidget {
  final String roomName;
  final String seats;
  final List<FABBasicInformation> fabInfoList;

  const _SeatAndFabSection({
    required this.roomName,
    required this.seats,
    required this.fabInfoList,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [_buildSeatInfo(), _buildFabInfo()]),
    );
  }

  Widget _buildSeatInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.event_seat, color: Colors.black, size: 50),

          const SizedBox(height: MIN_HEIGHT_SIZED_BOX),

          Text(
            roomName,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            seats,
            style: const TextStyle(color: Colors.black, fontSize: TITLE_H3),
          ),
        ],
      ),
    );
  }

  Widget _buildFabInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.fastfood, color: Colors.black, size: 50),

          const SizedBox(height: MIN_HEIGHT_SIZED_BOX),

          const Text(
            'Đồ ăn & Thức uống',
            style: TextStyle(
              fontSize: TITLE_H2,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          _buildFabList(),
        ],
      ),
    );
  }

  Widget _buildFabList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 60),
      child: SingleChildScrollView(
        child: Column(
          children:
              fabInfoList
                  .map(
                    (fab) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '${fab.name} x${fab.quantity}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: TITLE_H3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

// ===== PRICE SECTION =====
class _PriceSection extends StatelessWidget {
  final String total;

  const _PriceSection({required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
      child: Row(
        children: [
          const Icon(Icons.money_off_rounded, color: Colors.black, size: 28),

          const SizedBox(width: 8),

          Text(
            formatCurrency(double.parse(total)),
            style: const TextStyle(
              fontSize: TITLE_H2,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== LOCATION SECTION =====
class _LocationSection extends StatelessWidget {
  final String city;
  final String cinemaLocation;

  const _LocationSection({required this.city, required this.cinemaLocation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.black, size: 30),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              "${CITIES[city].toString()}, $cinemaLocation",
              style: const TextStyle(color: Colors.black, fontSize: TITLE_H2),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== QR INSTRUCTION SECTION =====
class _QRInstructionSection extends StatelessWidget {
  const _QRInstructionSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        children: [
          Icon(Icons.qr_code_scanner, color: Colors.black, size: 30),

          SizedBox(width: 8),

          Expanded(
            child: Text(
              'Hiển thị mã QR này tại quầy bán vé để nhận vé của bạn',
              style: TextStyle(
                color: Colors.black,
                fontSize: TITLE_H2,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== BARCODE SECTION =====
class _BarcodeSection extends StatelessWidget {
  final int orderId;

  const _BarcodeSection({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          BarcodeWidget(
            barcode: Barcode.code128(),
            data: '78889377726',
            width: 250,
            height: 80,
          ),

          Text(
            "Order id: $orderId",
            style: TextStyle(fontSize: TITLE_H3, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

// ===== CUSTOM PAINTER =====
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw semi-circles on the sides
    final circlePaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(-10, size.height / 2), 10, circlePaint);
    canvas.drawCircle(
      Offset(size.width + 10, size.height / 2),
      10,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _ContinuationButton extends StatelessWidget {
  const _ContinuationButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Tiếp tục',
          style: TextStyle(
            fontSize: TEXT_BUTTON_SIZE_AT_THE_END,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
