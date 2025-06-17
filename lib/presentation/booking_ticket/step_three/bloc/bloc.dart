import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_mobile/core/constants/others.dart';

import 'package:rt_mobile/data/repositories/payment.dart';

import 'package:url_launcher/url_launcher.dart';

part 'event.dart';
part 'state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc({required this.paymentRepository}) : super(PaymentInitial()) {
    on<PaymentCreated>(_onCreated);
    on<PaymentProcessing>(_onProcessing);
    on<PaymentCompleted>(_onCompleted);
    on<PaymentReset>(_onReset);
  }

  Future<void> _onCreated(
    PaymentCreated event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final paymentUrl = await paymentRepository.createPaymentURL(
        orderId: event.orderId,
        amount: event.amount,
        accessToken: event.accessToken,
      );

      emit(
        PaymentUrlCreated(
          paymentUrl: paymentUrl,
          orderId: event.orderId,
          amount: event.amount,
        ),
      );
    } catch (e) {
      emit(PaymentFailure(errorMessage: e.toString(), orderId: event.orderId));
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
          paymentUrl: currentState.paymentUrl,
          orderId: currentState.orderId,
        ),
      );
    }
  }

  Future<void> _onCompleted(
    PaymentCompleted event,
    Emitter<PaymentState> emit,
  ) async {
    if (event.isSuccess) {
      // Có thể thêm logic verify payment từ server ở đây
      emit(
        PaymentSuccess(
          orderId:
              (state is PaymentInProgress)
                  ? (state as PaymentInProgress).orderId
                  : 0,
          transactionId: event.transactionId,
        ),
      );
    } else {
      emit(
        PaymentFailure(
          errorMessage: event.errorMessage ?? 'Payment failed',
          orderId:
              (state is PaymentInProgress)
                  ? (state as PaymentInProgress).orderId
                  : null,
        ),
      );
    }
  }

  Future<void> _onReset(PaymentReset event, Emitter<PaymentState> emit) async {
    emit(PaymentInitial());
  }

  // Helper method để launch payment URL
  Future<bool> launchPaymentUrl(String url) async {
    logger.i(url);
    try {
      final uri = Uri.parse(
        'momo://?action=payWithApp&partner=MOMO123456&amount=10000&orderId=abc123&orderInfo=Mua%20ve',
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
