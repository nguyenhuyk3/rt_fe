part of 'bloc.dart';

sealed class PaymentEvent {}

class PaymentCreated extends PaymentEvent {
  final int orderId;
  final int amount;

  PaymentCreated({required this.orderId, required this.amount});
}

class PaymentProcessing extends PaymentEvent {}

class PaymentCompleted extends PaymentEvent {
  final int statusCode;
  final String message;
  final TicketInformation ticketInformation;

  PaymentCompleted({
    required this.statusCode,
    required this.message,
    required this.ticketInformation,
  });
}

class PaymentReset extends PaymentEvent {}

class PaymentVerificationSuccess extends PaymentEvent {
  final TicketInformation ticketInformation;

  PaymentVerificationSuccess({required this.ticketInformation});
}

class PaymentVerificationFailed extends PaymentEvent {
  final String message;

  PaymentVerificationFailed({required this.message});
}

