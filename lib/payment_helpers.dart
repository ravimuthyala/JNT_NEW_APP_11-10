import 'shared/payment_type.dart';

String paymentTypeLabel(PaymentType type) {
  switch (type) {
    case PaymentType.applePay:
      return 'Apple Pay';
    case PaymentType.paypal:
      return 'PayPal';
    case PaymentType.creditCard:
      return 'Credit Card';
    case PaymentType.venmo:
      return 'Venmo';
  }
}