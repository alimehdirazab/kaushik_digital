class ReferalModel {
  final int id;
  final String registrationNo;
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
  final String dob;
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
    required this.registrationNo,
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
    required this.dob,
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
      id: json['id'],
      registrationNo: json['registration_no'],
      refrenceId: json['refrence_id'],
      usertype: json['usertype'],
      loginStatus: json['login_status'],
      googleId: json['google_id'],
      facebookId: json['facebook_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      otp: json['otp'],
      expiresAt: json['expires_at'],
      userAddress: json['user_address'],
      dob: json['dob'],
      userImage: json['user_image'],
      status: json['status'],
      planId: json['plan_id'],
      startDate: json['start_date'],
      expDate: json['exp_date'],
      paypalPaymentId: json['paypal_payment_id'],
      stripePaymentId: json['stripe_payment_id'],
      razorpayPaymentId: json['razorpay_payment_id'],
      paystackPaymentId: json['paystack_payment_id'],
      planAmount: json['plan_amount'],
      confirmationCode: json['confirmation_code'],
      sessionId: json['session_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
