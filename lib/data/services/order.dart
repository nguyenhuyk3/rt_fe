import 'package:dio/dio.dart';

import 'package:rt_mobile/data/models/api_response.dart';

class OrderService {
  final Dio dio;

  OrderService({required this.dio});

  Future<APIReponse> createOrder({
    required Map<String, dynamic> request,
    required String accessToken,
  }) async {
    final response = await dio.post(
      '/order_service/order/public/create',
      data: request,
    );

    return APIReponse(statusCode: response.statusCode, data: response.data);
  }
}
