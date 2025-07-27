class ReferalModel {
  final int id;
  final String? registrationNo;
  final String? refrenceId;
  final String usertype;
  final int loginStatus;
  final String? googleId;
  final String? facebookId;
  final String name;
  final String email;
  final String phone;
  final String? otp;
  final String? expiresAt;
  final String? userAddress;
  final String? dob;
  final String? userImage;
  final int status;
  final int planId;
  final String? startDate;
  final String? expDate;
  final String? paypalPaymentId;
  final String? stripePaymentId;
  final String? razorpayPaymentId;
  final String? paystackPaymentId;
  final String planAmount;
  final String? confirmationCode;
  final String? sessionId;
  final String createdAt;
  final String updatedAt;

  ReferalModel({
    required this.id,
    this.registrationNo,
    this.refrenceId,
    required this.usertype,
    required this.loginStatus,
    this.googleId,
    this.facebookId,
    required this.name,
    required this.email,
    required this.phone,
    this.otp,
    this.expiresAt,
    this.userAddress,
    this.dob,
    this.userImage,
    required this.status,
    required this.planId,
    this.startDate,
    this.expDate,
    this.paypalPaymentId,
    this.stripePaymentId,
    this.razorpayPaymentId,
    this.paystackPaymentId,
    required this.planAmount,
    this.confirmationCode,
    this.sessionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReferalModel.fromJson(Map<String, dynamic> json) {
    return ReferalModel(
      id: json['id'] ?? 0,
      registrationNo: json['registration_no']?.toString(),
      refrenceId: json['refrence_id']?.toString(),
      usertype: json['usertype'] ?? '',
      loginStatus: json['login_status'] ?? 0,
      googleId: json['google_id']?.toString(),
      facebookId: json['facebook_id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      otp: json['otp']?.toString(),
      expiresAt: json['expires_at']?.toString(),
      userAddress: json['user_address']?.toString(),
      dob: json['dob']?.toString(),
      userImage: json['user_image']?.toString(),
      status: json['status'] ?? 0,
      planId: json['plan_id'] ?? 0,
      startDate: json['start_date']?.toString(),
      expDate: json['exp_date']?.toString(),
      paypalPaymentId: json['paypal_payment_id']?.toString(),
      stripePaymentId: json['stripe_payment_id']?.toString(),
      razorpayPaymentId: json['razorpay_payment_id']?.toString(),
      paystackPaymentId: json['paystack_payment_id']?.toString(),
      planAmount: json['plan_amount']?.toString() ?? '',
      confirmationCode: json['confirmation_code']?.toString(),
      sessionId: json['session_id']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}
