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

// cities
const CITIES = {'HO_CHI_MINH': 'Hồ Chí Minh'};

var SCREENS = [HomeScreen(), const LoginScreen()];

const double HEADER_SIZE = 22;
const double MIN_HEIGHT_SIZED_BOX = 8;
const double MAX_HEIGTH_SIZED_BOX = 12;
const double TEXT_BUTTON_SIZE_AT_THE_END = 18;
const double TITLE_H1 = 18;
const double TITLE_H2 = 16;
const double TITLE_H3 = 14;
const double TITLE_H4 = 12;

const REAL_ACCESS_TOKEN =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImI2ODk2ZTVmLTE3NzEtNGMyNy04YjYwLTg4MDdkNGU2ZTExZSIsImlzcyI6ImE0MDRmMWMxLTcwNTgtNGFmNy05NzZhLTNhYWY2Zjc0MmZlOCIsImVtYWlsIjoiaHV5a2ltY3Vvbmc1QGdtYWlsLmNvbSIsInJvbGUiOiJjdXN0b21lciIsImlzc3VlZF9hdCI6IjIwMjUtMDYtMTlUMTk6MzE6MTUuODgzNzcxNyswNzowMCIsImlzc3VlZCI6MTc1MDMzNjI3NSwiZXhwaXJlZF9hdCI6IjIwMjUtMDYtMjFUMjE6MzE6MTUuODgzNzcxNyswNzowMCIsImV4cCI6MTc1MDUxNjI3NX0.QQ7LdGEHtWu9xcRyDM9vmP1WeF67oB42Dvumr0hVEWk';
