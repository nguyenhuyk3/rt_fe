import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:rt_mobile/core/constants/others.dart';

// ===== MODELS =====
class BasicFABInfo {
  final String name;
  final int quantity;

  BasicFABInfo({required this.name, required this.quantity});

  factory BasicFABInfo.fromJson(Map<String, dynamic> json) {
    return BasicFABInfo(name: json['name'], quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity};
  }
}

// ===== MAIN SCREEN =====
class MovieTicketScreen extends StatelessWidget {
  final String imageUrl;
  final String filmDuration;
  final String genres;
  final String seats;
  final String total;
  final String cinemaLocation;
  final List<BasicFABInfo> fabInfoList;

  const MovieTicketScreen({
    super.key,
    required this.imageUrl,
    required this.filmDuration,
    required this.genres,
    required this.seats,
    required this.total,
    required this.cinemaLocation,
    required this.fabInfoList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [_buildTicketContainer()]),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: const Text(
        'Vé của tôi',
        style: TextStyle(
          color: Colors.white,
          fontSize: titleSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTicketContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _MovieInfoSection(
            imageUrl: imageUrl,
            filmDuration: filmDuration,
            genres: genres,
          ),

          _SeatAndFabSection(seats: seats, fabInfoList: fabInfoList),

          const SizedBox(height: 12),

          const Divider(height: 1, color: Colors.black, thickness: 0.6),

          _PriceSection(total: total),

          _LocationSection(cinemaLocation: cinemaLocation),

          const _QRInstructionSection(),

          const SizedBox(height: 12),

          _buildDottedLine(),

          const _BarcodeSection(),
        ],
      ),
    );
  }

  Widget _buildDottedLine() {
    return CustomPaint(
      size: const Size(double.infinity, 20),
      painter: DottedLinePainter(),
    );
  }
}

// ===== MOVIE INFO SECTION =====
class _MovieInfoSection extends StatelessWidget {
  final String imageUrl;
  final String filmDuration;
  final String genres;

  const _MovieInfoSection({
    required this.imageUrl,
    required this.filmDuration,
    required this.genres,
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
          const Text(
            'Avengers: Infinity War',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.access_time, filmDuration),
          const SizedBox(height: 4),
          _buildDetailRow(Icons.local_movies, genres),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ],
    );
  }
}

// ===== SEAT AND FAB SECTION =====
class _SeatAndFabSection extends StatelessWidget {
  final String seats;
  final List<BasicFABInfo> fabInfoList;

  const _SeatAndFabSection({required this.seats, required this.fabInfoList});

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
          const SizedBox(height: 8),
          const Text(
            'Room name',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            seats,
            style: const TextStyle(color: Colors.black, fontSize: 14),
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
          const SizedBox(height: 8),
          const Text(
            'Đồ ăn & Thức uống',
            style: TextStyle(
              fontSize: 16,
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
      constraints: const BoxConstraints(maxHeight: 80),
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
                          fontSize: 14,
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
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Icon(Icons.money_off_rounded, color: Colors.black, size: 30),
          const SizedBox(width: 8),
          Text(
            total,
            style: const TextStyle(
              fontSize: 16,
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
  final String cinemaLocation;

  const _LocationSection({required this.cinemaLocation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.black, size: 30),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              cinemaLocation,
              style: const TextStyle(color: Colors.black, fontSize: 14),
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.qr_code_scanner, color: Colors.black, size: 30),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Hiển thị mã QR này tại quầy bán vé để nhận vé của bạn',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== BARCODE SECTION =====
class _BarcodeSection extends StatelessWidget {
  const _BarcodeSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          BarcodeWidget(
            barcode: Barcode.code128(),
            data: '78889377726',
            width: 250,
            height: 80,
          ),
          const SizedBox(height: 8),
          const Text(
            'Order ID: 78889377726',
            style: TextStyle(fontSize: 12, color: Colors.black),
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
