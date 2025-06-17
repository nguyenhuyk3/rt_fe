import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rt_mobile/core/constants/others.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';

class MoMoRedirectScreen extends StatefulWidget {
  const MoMoRedirectScreen({super.key});

  @override
  State<MoMoRedirectScreen> createState() => _MoMoRedirectScreenState();
}

class _MoMoRedirectScreenState extends State<MoMoRedirectScreen> {
  final TextEditingController _controller = TextEditingController();
  StreamSubscription? _sub;
  String? _resultMessage;
  final AppLinks _appLinks = AppLinks();
  final dioClient = Dio(BaseOptions(baseUrl: 'http://192.168.204.1:5007'));

  @override
  void initState() {
    super.initState();
    _listenToDeepLink();
  }

  void _listenToDeepLink() async {
    try {
      // Lắng nghe khi app đã mở
      _sub = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          _handleUri(uri);
        },
        onError: (err) {
          debugPrint('Error receiving app link: $err');
        },
      );

      // Xử lý khi app mở bằng deeplink từ trạng thái tắt (cold start)
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
    } catch (e) {
      debugPrint('Error setting up app links: $e');
    }
  }

  void _handleUri(Uri uri) async {
    if (!mounted) return;

    logger.i('Deep link: ${uri.toString()}');
    logger.i('Deep link: ${uri.toString()}');
    logger.i('Scheme: ${uri.scheme}');
    logger.i('Host: ${uri.host}');
    logger.i('Path: ${uri.path}');

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

      try {
        final response = await dioClient.get(
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

        final data = response.data;

        logger.e(data);

        if (data['success'] == true) {
          final status = data['data']['status'];
          final backendMessage = data['message'] ?? '';
          setState(() {
            _resultMessage = '✅ Thành công: $backendMessage ($status)';
          });
        } else {
          setState(() {
            _resultMessage =
                '❌ Thất bại: ${data['message'] ?? 'Không rõ lý do'}';
          });
        }
      } catch (e) {
        logger.e('Lỗi gọi verify_payment: $e');
        setState(() {
          _resultMessage = '❌ Có lỗi xảy ra khi xác minh thanh toán.';
        });
      }

      if (mounted && _resultMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_resultMessage!)));
      }
    }
  }

  void _openMoMoApp() async {
    final scheme = _controller.text.trim();

    if (scheme.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập deeplink URI')),
        );
      }
      return;
    }

    try {
      final uri = Uri.parse(scheme);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể mở app MoMo')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('URI không hợp lệ')));
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mở MoMo qua deeplink')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nhập deeplink URI',
                border: OutlineInputBorder(),
                hintText: 'Ví dụ: momo://payment?amount=10000',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _openMoMoApp,
              child: const Text('Mở MoMo'),
            ),
            const SizedBox(height: 24),
            if (_resultMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _resultMessage!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
