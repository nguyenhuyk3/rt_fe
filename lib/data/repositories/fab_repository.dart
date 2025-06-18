import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/models/product/fab.product.dart';
import 'package:rt_mobile/data/services/fab.dart';

class FABRepository {
  final FABService fABService;

  const FABRepository({required this.fABService});

  Future<List<FABProduct>> getAllFABs() async {
    final response = await fABService.getAllFABs();

    if (response.isSuccess) {
      final rawData = response.data['data'];

      if (rawData is List) {
        logger.i(rawData);
        return rawData.map((fAB) => FABProduct.fromJson(fAB)).toList();
      } else {
        throw Exception("invalid data format");
      }
    } else {
      throw Exception(
        'failed to fetch cinemas for all fabs (status code: ${response.statusCode})',
      );
    }
  }
}
