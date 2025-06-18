import 'package:dio/dio.dart';
import 'package:rt_mobile/data/models/api_response.dart';

class FABService {
  final Dio dio;

  const FABService({required this.dio});

  Future<APIReponse> getAllFABs() async {
    final response = await dio.get('/product_service/fab/public/get_all');

    return APIReponse(statusCode: response.statusCode, data: response.data);
  }
}
