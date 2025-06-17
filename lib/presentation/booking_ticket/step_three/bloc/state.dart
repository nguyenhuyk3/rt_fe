part of 'bloc.dart';

sealed class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentUrlCreated extends PaymentState {
  final String paymentUrl;
  final int orderId;
  final int amount;

  PaymentUrlCreated({
    required this.paymentUrl,
    required this.orderId,
    required this.amount,
  });
}

class PaymentInProgress extends PaymentState {
  final String paymentUrl;
  final int orderId;

  PaymentInProgress({required this.paymentUrl, required this.orderId});
}

class PaymentSuccess extends PaymentState {
  final int orderId;
  final String? transactionId;

  PaymentSuccess({required this.orderId, this.transactionId});
}

class PaymentFailure extends PaymentState {
  final String errorMessage;
  final int? orderId;

  PaymentFailure({required this.errorMessage, this.orderId});
}
