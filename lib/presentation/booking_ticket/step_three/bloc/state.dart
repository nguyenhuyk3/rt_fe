part of 'bloc.dart';

sealed class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentUrlCreated extends PaymentState {
  final String paymentDeepLink;
  final int orderId;
  final int amount;

  PaymentUrlCreated({
    required this.paymentDeepLink,
    required this.orderId,
    required this.amount,
  });
}

class PaymentInProgress extends PaymentState {
  final String paymentDeepLink;
  final int orderId;

  PaymentInProgress({required this.paymentDeepLink, required this.orderId});
}

class PaymentSuccess extends PaymentState {
  final TicketInformation ticketInformation;

  PaymentSuccess({required this.ticketInformation});
}

class PaymentFailure extends PaymentState {
  final String message;

  PaymentFailure({required this.message});
}
