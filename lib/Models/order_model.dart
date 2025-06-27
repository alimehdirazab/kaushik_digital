class OrderModel {
  final String orderId;
  final int amount;
  final String currency;
  final String status;

  OrderModel({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.status,
  });

  // Factory method to create an OrderModel object from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
    );
  }

  // Method to convert an OrderModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'amount': amount,
      'currency': currency,
      'status': status,
    };
  }
}
