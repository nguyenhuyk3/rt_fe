// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:rt_mobile/data/services/secure_storage.dart';
import 'package:rt_mobile/presentation/authentication/login/view/login_screen.dart';
import 'package:rt_mobile/presentation/home/home_screen.dart';

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
const BASE_URL = 'http://192.168.2.70:8000';

var SCREENS = [
  // MovieTicketScreen(
  //   imageUrl: 'https://example.com/avengers-poster.jpg',
  //   filmDuration: '2 hours 29 minutes',
  //   genres: 'Action, adventure, sci-fi',
  //   seats: 'Seat H7, H8',
  //   total: '210.000 VND',
  //   cinemaLocation: '4th floor, Vincom Ocean Park, Da Ton, Gia Lam, Ha Noi',
  //   fabInfoList: [
  //     BasicFABInfo(name: 'Bắp rang bơ lớn', quantity: 2),
  //     BasicFABInfo(name: 'Coca Cola', quantity: 2),
  //     BasicFABInfo(name: 'Kẹo socola', quantity: 1),
  //     BasicFABInfo(name: 'Nước cam ép', quantity: 1),
  //     BasicFABInfo(name: 'Bánh quy', quantity: 3),
  //     BasicFABInfo(name: 'Nước suối', quantity: 2),
  //   ],
  // ),
  HomeScreen(),
  const LoginScreen(),
];

const double titleSize = 22;
const REAL_ACCESS_TOKEN = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjdlMDEwYjlmLTIzYmMtNDM3Zi1iMDU3LTVjZGU2MTRmYTkyNiIsImlzcyI6ImE0MDRmMWMxLTcwNTgtNGFmNy05NzZhLTNhYWY2Zjc0MmZlOCIsImVtYWlsIjoiaHV5a2ltY3Vvbmc1QGdtYWlsLmNvbSIsInJvbGUiOiJjdXN0b21lciIsImlzc3VlZF9hdCI6IjIwMjUtMDYtMThUMTg6Mjg6MzQuMDExOTQ2NSswNzowMCIsImlzc3VlZCI6MTc1MDI0NjExNCwiZXhwaXJlZF9hdCI6IjIwMjUtMDYtMjBUMjA6Mjg6MzQuMDExOTQ2NSswNzowMCIsImV4cCI6MTc1MDQyNjExNH0.azwV30Fhm-uWi6fPWujKgR_s3PHTCU6OabLxIakExJ4';
