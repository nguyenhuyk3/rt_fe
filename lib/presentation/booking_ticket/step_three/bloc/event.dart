part of 'bloc.dart';

sealed class PaymentEvent {}

class PaymentCreated extends PaymentEvent {
  final int orderId;
  final int amount;
  final String accessToken;

  PaymentCreated({
    required this.orderId,
    required this.amount,
    required this.accessToken,
  });
}

class PaymentProcessing extends PaymentEvent {}

class PaymentCompleted extends PaymentEvent {
  final bool isSuccess;
  final String? transactionId;
  final String? errorMessage;

  PaymentCompleted({
    required this.isSuccess,
    this.transactionId,
    this.errorMessage,
  });
}

class PaymentReset extends PaymentEvent {}
