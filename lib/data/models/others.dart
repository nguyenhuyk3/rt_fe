class FABBasicInformation {
  final String name;
  final int quantity;

  FABBasicInformation({required this.name, required this.quantity});

  factory FABBasicInformation.fromJson(Map<String, dynamic> json) {
    return FABBasicInformation(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }
}

class TicketInformation {
  final int orderId;
  final int totalAmount;
  final String cinemaName;
  final String city;
  final String location;
  final String showDate;
  final String startTime;
  final String roomName;
  final String seats;
  final String genres;
  final String filmPoster;
  final String title;
  final String duration;
  final List<FABBasicInformation> fABs;

  TicketInformation({
    required this.orderId,
    required this.totalAmount,
    required this.cinemaName,
    required this.city,
    required this.location,
    required this.showDate,
    required this.startTime,
    required this.roomName,
    required this.seats,
    required this.genres,
    required this.filmPoster,
    required this.title,
    required this.duration,
    required this.fABs,
  });

  factory TicketInformation.fromJson(Map<String, dynamic> json) {
    return TicketInformation(
      orderId: json['order_id'] ?? 0,
      totalAmount: json['total_amount'] ?? 0,
      cinemaName: json['cinema_name'] ?? '',
      city: json['city'] ?? '',
      location: json['location'] ?? '',
      showDate: json['show_date'] ?? '',
      startTime: json['start_time'] ?? '',
      roomName: json['room_name'] ?? '',
      seats: json['seats'] ?? '',
      genres: json['genres'] ?? '',
      filmPoster: json['film_poster'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      fABs:
          (json['fABs'] as List<dynamic>? ?? [])
              .map((e) => FABBasicInformation.fromJson(e))
              .toList(),
    );
  }
}
