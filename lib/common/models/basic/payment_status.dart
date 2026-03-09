class PaymentStatusModel {
  final bool status;
  final String message;
  final String pgName;
  final String? paymentId;
  final bool isLive;

  PaymentStatusModel({
    required this.status,
    required this.message,
    required this.pgName,
    required this.isLive,
    this.paymentId,
  });

  static PaymentStatusModel failed(String pgName, [String? message]) =>
      PaymentStatusModel(
        status: false,
        message: message ?? "Failed to make payment",
        pgName: pgName,
        isLive: false,
      );

  @override
  String toString() {
    return "PaymentStatus(status:$status,message:$message,paymentId:$paymentId,isLive:$isLive)";
  }
}
