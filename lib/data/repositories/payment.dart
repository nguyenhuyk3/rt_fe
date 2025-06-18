import 'package:rt_mobile/data/services/payment.dart';

class PaymentRepository {
  final PaymentService paymentService;

  PaymentRepository({required this.paymentService});

  Future<String> createPaymentResponse({
    required int orderId,
    required int amount,
    required String accessToken,
  }) async {
    final response = await paymentService.createPaymentResponse(
      orderId: orderId,
      amount: amount,
      accessToken: accessToken,
    );

    if (response.isSuccess) {
      final rawData = response.data['data'];

      if (rawData is Map && rawData['deep_link'] is String) {
        return rawData['deep_link'];
      } else {
        throw Exception("invalid response format: missing deep_link");
      }
    } else {
      throw Exception(
        'failed to create payment response (status code: ${response.statusCode})',
      );
    }
  }
}
