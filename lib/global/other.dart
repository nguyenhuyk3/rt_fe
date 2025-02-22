// ignore_for_file: constant_identifier_names

import 'package:logger/logger.dart';
import 'package:app_logger/app_logger.export.dart' as app_logger;

final appLogger = app_logger.AppLogger();
final logger = Logger();

const MINIMUM_LENGTH_FOR_PASSWORD = 8;

const LENGTH_OF_OTP = 6;

const TIME_FOR_RESENDING_MAIL = 10;
