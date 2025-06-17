// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:rt_mobile/app/paymentSuccess.dart';
import 'package:rt_mobile/data/services/secure_storage.dart';
import 'package:rt_mobile/presentation/authentication/login/view/login_screen.dart';

// loggers
final logger = Logger();

// dio options
final VALIDATE_ALL_STATUSES = Options(
  validateStatus: (status) => status != null && status < 506,
);

final storage = SecureStorageService();

// storage key
const ACCESS_TOKEN = 'access_token';
const REFRESH_TOKEN = 'refresh_token';

// others
const MINIMUM_LENGTH_FOR_PASSWORD = 8;
const LENGTH_OF_OTP = 6;
const TIME_FOR_RESENDING_MAIL = 10;
const BASE_URL = 'http://192.168.1.19:8000';

var SCREENS = [
  MovieTicketScreen(
    imageUrl: 'https://example.com/avengers-poster.jpg',
    filmDuration: '2 hours 29 minutes',
    genres: 'Action, adventure, sci-fi',
    seats: 'Seat H7, H8',
    total: '210.000 VND',
    cinemaLocation: '4th floor, Vincom Ocean Park, Da Ton, Gia Lam, Ha Noi',
    fabInfoList: [
      BasicFABInfo(name: 'Bắp rang bơ lớn', quantity: 2),
      BasicFABInfo(name: 'Coca Cola', quantity: 2),
      BasicFABInfo(name: 'Kẹo socola', quantity: 1),
      BasicFABInfo(name: 'Nước cam ép', quantity: 1),
      BasicFABInfo(name: 'Bánh quy', quantity: 3),
      BasicFABInfo(name: 'Nước suối', quantity: 2),
    ],
  ),
  const LoginScreen(),
];

const double titleSize = 22;
