
import 'package:rt_mobile/data/models/product/fab.product.dart';

class Ticket {
  final String posterUrl;
  final String filmDuration;
  final String genres;
  final String seats;
  final String total;
  final String cinemaLocation;
  final List<BasicFABInfo> fABs;

  Ticket({
    required this.posterUrl,
    required this.filmDuration,
    required this.genres,
    required this.seats,
    required this.total,
    required this.cinemaLocation,
    required this.fABs,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      posterUrl: json['poster_url'],
      filmDuration: json['film_duration'],
      genres: json['genres'],
      seats: json['seats'],
      total: json['total'],
      cinemaLocation: json['cinema_location'],
      fABs: (json['fABs'] as List<dynamic>)
          .map((e) => BasicFABInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poster_url': posterUrl,
      'film_duration': filmDuration,
      'genres': genres,
      'seats': seats,
      'total': total,
      'cinema_location': cinemaLocation,
      'fABs': fABs.map((e) => e.toJson()).toList(),
    };
  }
}
