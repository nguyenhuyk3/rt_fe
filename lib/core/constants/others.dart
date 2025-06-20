// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:dio/dio.dart';

import 'package:logger/logger.dart';

import 'package:rt_mobile/data/services/secure_storage.dart';
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
const EMAIL = 'email';

// others
const MINIMUM_LENGTH_FOR_PASSWORD = 8;
const LENGTH_OF_OTP = 6;
const TIME_FOR_RESENDING_MAIL = 10;
const BASE_URL = 'http://192.168.2.70:8000';

// cities
const CITIES = {'HO_CHI_MINH': 'Hồ Chí Minh'};

var SCREENS = [HomeScreen(), HomeScreen()];

const double HEADER_SIZE = 22;
const double MIN_HEIGHT_SIZED_BOX = 8;
const double MAX_HEIGTH_SIZED_BOX = 12;
const double TEXT_BUTTON_SIZE_AT_THE_END = 18;
const double TITLE_H0 = 20;
const double TITLE_H1 = 18;
const double TITLE_H2 = 16;
const double TITLE_H3 = 14;
const double TITLE_H4 = 12;
