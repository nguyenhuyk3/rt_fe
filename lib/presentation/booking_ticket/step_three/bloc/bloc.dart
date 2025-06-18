import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/models/others.dart';

import 'package:rt_mobile/data/repositories/payment.dart';

import 'package:url_launcher/url_launcher.dart';

part 'event.dart';
part 'state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  final Dio localhostDioClient = Dio(
    BaseOptions(baseUrl: 'http://192.168.2.70:5007'),
  );
  final AppLinks _appLinks = AppLinks();

  StreamSubscription? _deepLinkSubscription;

  PaymentBloc({required this.paymentRepository}) : super(PaymentInitial()) {
    on<PaymentCreated>(_onCreated);
    on<PaymentProcessing>(_onProcessing);
    on<PaymentCompleted>(_onCompleted);
    on<PaymentReset>(_onReset);
    on<PaymentVerificationSuccess>(_onVerificationSuccess);
    on<PaymentVerificationFailed>(_onVerificationFailed);

    _listenToDeepLink();
  }

  @override
  Future<void> close() {
    _deepLinkSubscription?.cancel();

    return super.close();
  }

  void _listenToDeepLink() async {
    try {
      _deepLinkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          _handleUri(uri);
        },
        onError: (err) {
          add(PaymentVerificationFailed(message: err.toString()));
        },
      );

      // // Xử lý khi app mở bằng deeplink từ trạng thái tắt (cold start)
      // final Uri? initialUri = await _appLinks.getInitialLink();

      // if (initialUri != null) {
      //   _handleUri(initialUri);
      // }
    } catch (e) {
      add(PaymentVerificationFailed(message: e.toString()));
    }
  }

  void _handleUri(Uri uri) async {
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
        final response = await localhostDioClient.get(
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

        if (response.statusCode == 200) {
          final ticketInformationJson = data['data']['ticket_information'];
          final ticketInformation = TicketInformation.fromJson(
            ticketInformationJson,
          );

          logger.f("lksjl1111");
          add(PaymentVerificationSuccess(ticketInformation: ticketInformation));
        } else {
          add(
            PaymentVerificationFailed(
              message: data['message'] ?? 'Thanh toán thất bại',
            ),
          );
        }
      } catch (e) {
        add(PaymentVerificationFailed(message: e.toString()));
      }
    }
  }

  Future<void> _onCreated(
    PaymentCreated event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final paymenDeepLink = await paymentRepository.createPaymentResponse(
        orderId: event.orderId,
        amount: event.amount,
        accessToken: REAL_ACCESS_TOKEN,
      );

      emit(
        PaymentUrlCreated(
          paymentDeepLink: paymenDeepLink,
          orderId: event.orderId,
          amount: event.amount,
        ),
      );
    } catch (e) {
      emit(PaymentFailure(message: e.toString()));
    }
  }

  Future<void> _onProcessing(
    PaymentProcessing event,
    Emitter<PaymentState> emit,
  ) async {
    if (state is PaymentUrlCreated) {
      final currentState = state as PaymentUrlCreated;

      emit(
        PaymentInProgress(
          paymentDeepLink: currentState.paymentDeepLink,
          orderId: currentState.orderId,
        ),
      );
    }
  }

  Future<void> _onCompleted(
    PaymentCompleted event,
    Emitter<PaymentState> emit,
  ) async {}

  Future<void> _onReset(PaymentReset event, Emitter<PaymentState> emit) async {
    emit(PaymentInitial());
  }

  Future<bool> launchPaymentUrl(String url) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  FutureOr<void> _onVerificationSuccess(
    PaymentVerificationSuccess event,
    Emitter<PaymentState> emit,
  ) {
    emit(PaymentSuccess(ticketInformation: event.ticketInformation));
  }

  FutureOr<void> _onVerificationFailed(
    PaymentVerificationFailed event,
    Emitter<PaymentState> emit,
  ) {
    emit(PaymentFailure(message: event.message));
  }
}
