import 'package:dio/dio.dart';

import 'package:rt_mobile/data/models/api_response.dart';

class PaymentService {
  final Dio dio;
  final Dio dioLocalhost = Dio(
    BaseOptions(baseUrl: 'http://192.168.204.1:5007'),
  );

  PaymentService({required this.dio});

  Future<APIReponse> createPaymentResponse({
    required int orderId,
    required int amount,
    required String accessToken,
  }) async {
    final response = await dio.post(
      '/payment_service/momo/customer/create_payment_response',
      data: {'order_id': orderId, 'amount': amount, 'platform': 'mobile'},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    return APIReponse(statusCode: response.statusCode, data: response.data);
  }

  Future<APIReponse> verifypayment({required Uri uri}) async {
    if (uri.host == 'payment-result') {
      final amount = uri.queryParameters['amount'];
      final transId = uri.queryParameters['transId'];
      final resultCode = uri.queryParameters['resultCode'];
      final message = uri.queryParameters['message'] ?? '';
      final extraData = uri.queryParameters['extraData'];
      final orderId = uri.queryParameters['orderId'];
      final requestId = uri.queryParameters['requestId'];
      final orderInfo = uri.queryParameters['orderInfo'];
      final orderType = uri.queryParameters['orderType'];
      final payType = uri.queryParameters['payType'];
      final responseTime = uri.queryParameters['responseTime'];
      final signature = uri.queryParameters['signature'];
      final partnerCode = uri.queryParameters['partnerCode'];

      final response = await dio.get(
        '/v1/momo/customer/verify_payment',
        queryParameters: {
          'amount': amount,
          'transId': transId,
          'resultCode': resultCode,
          'message': message,
          'extraData': extraData,
          'orderId': orderId,
          'requestId': requestId,
          'orderInfo': orderInfo,
          'orderType': orderType,
          'payType': payType,
          'responseTime': responseTime,
          'signature': signature,
          'partnerCode': partnerCode,
        },
      );

      return APIReponse(statusCode: response.statusCode, data: response.data);
    } else {
      return APIReponse(statusCode: 400, data: {'message': 'invalid uri host'});
    }
  }
}
