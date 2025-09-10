class PaymentVerificationModel {
  final bool success;
  final String message;
  final String? regId;
  final Map<String, dynamic>? paymentDetails;

  PaymentVerificationModel({
    required this.success,
    required this.message,
    this.regId,
    this.paymentDetails,
  });

  factory PaymentVerificationModel.fromJson(Map<String, dynamic> json) {
    // Check for explicit success field first
    bool isSuccessful = json['success'] == "1" || json['success'] == true;
    
    // If no success field, check if message indicates success
    if (!isSuccessful && json['message'] != null) {
      String message = json['message'].toString().toLowerCase();
      isSuccessful = message.contains('success') || message.contains('verified');
    }
    
    return PaymentVerificationModel(
      success: isSuccessful,
      message: json['msg'] ?? json['message'] ?? '',
      regId: json['reg_id']?.toString(),
      paymentDetails: json['payment_details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'reg_id': regId,
      'payment_details': paymentDetails,
    };
  }
}
