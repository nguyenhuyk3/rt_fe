import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/services/order.dart';

class OrderRepository {
  final OrderService orderService;

  OrderRepository({required this.orderService});

  Future<int> createOrder({required Map<String, dynamic> request}) async {
    final response = await orderService.createOrder(
      request: request,
      accessToken: REAL_ACCESS_TOKEN,
    );

    if (response.isSuccess) {
      final rawData = response.data['data'];

      if (rawData != null && rawData['order_id'] != null) {
        final orderId = rawData['order_id'] as int;

        return orderId;
      } else {
        throw Exception('response do not contain order_id');
      }
    } else {
      throw Exception(
        'failed to create order (status code: ${response.statusCode})',
      );
    }
  }
}
