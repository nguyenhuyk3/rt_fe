import 'package:dio/dio.dart';
import 'package:rt_mobile/core/constants/others.dart';

import 'package:rt_mobile/data/models/api_response.dart';

class OrderService {
  final Dio dio;

  OrderService({required this.dio});

  Future<APIReponse> createOrder({
    required Map<String, dynamic> request,
  }) async {
    final token = await storage.read(ACCESS_TOKEN);
    logger.i(token);
    final response = await dio.post(
      '/order_service/order/public/create',
      data: request,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return APIReponse(statusCode: response.statusCode, data: response.data);
  }
}
