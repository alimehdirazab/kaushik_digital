class UserDetailModel {
  List<VIDEOSTREAMINGAPP>? vIDEOSTREAMINGAPP;
  int? statusCode;

  UserDetailModel({this.vIDEOSTREAMINGAPP, this.statusCode});

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['VIDEO_STREAMING_APP'] != null) {
      vIDEOSTREAMINGAPP = <VIDEOSTREAMINGAPP>[];
      json['VIDEO_STREAMING_APP'].forEach((v) {
        vIDEOSTREAMINGAPP!.add(VIDEOSTREAMINGAPP.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vIDEOSTREAMINGAPP != null) {
      data['VIDEO_STREAMING_APP'] =
          vIDEOSTREAMINGAPP!.map((v) => v.toJson()).toList();
    }
    data['status_code'] = statusCode;
    return data;
  }
}

class VIDEOSTREAMINGAPP {
  int? userId;
  String? name;
  String? email;
  String? userImage;
  String? currentPlan;
  String? expiresOn;
  String? lastInvoiceDate;
  String? lastInvoicePlan;
  String? lastInvoiceAmount;
  String? msg;
  String? success;

  VIDEOSTREAMINGAPP(
      {this.userId,
      this.name,
      this.email,
      this.userImage,
      this.currentPlan,
      this.expiresOn,
      this.lastInvoiceDate,
      this.lastInvoicePlan,
      this.lastInvoiceAmount,
      this.msg,
      this.success});

  VIDEOSTREAMINGAPP.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    userImage = json['user_image'];
    currentPlan = json['current_plan'];
    expiresOn = json['expires_on'];
    lastInvoiceDate = json['last_invoice_date'];
    lastInvoicePlan = json['last_invoice_plan'];
    lastInvoiceAmount = json['last_invoice_amount'];
    msg = json['msg'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['user_image'] = userImage;
    data['current_plan'] = currentPlan;
    data['expires_on'] = expiresOn;
    data['last_invoice_date'] = lastInvoiceDate;
    data['last_invoice_plan'] = lastInvoicePlan;
    data['last_invoice_amount'] = lastInvoiceAmount;
    data['msg'] = msg;
    data['success'] = success;
    return data;
  }
}







// class UserDetailsModel {
//   int userId;
//   String name;
//   String email;
//   String userImage;
//   String currentPlan;
//   String expiresOn;
//   String lastInvoiceDate;
//   String lastInvoicePlan;
//   String lastInvoiceAmount;
//   String msg;
//   String success;
//   VideoStreamingApp videoStreamingApp;

//   UserDetailsModel({
//     required this.userId,
//     required this.name,
//     required this.email,
//     required this.userImage,
//     required this.currentPlan,
//     required this.expiresOn,
//     required this.lastInvoiceDate,
//     required this.lastInvoicePlan,
//     required this.lastInvoiceAmount,
//     required this.msg,
//     required this.success,
//     required this.videoStreamingApp,
//   });

//   factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
//         userId: json['VIDEO_STREAMING_APP'][0]['user_id'],
//         name: json['VIDEO_STREAMING_APP'][0]['name'],
//         email: json['VIDEO_STREAMING_APP'][0]['email'],
//         userImage: json['VIDEO_STREAMING_APP'][0]['user_image'],
//         currentPlan: json['VIDEO_STREAMING_APP'][0]['current_plan'],
//         expiresOn: json['VIDEO_STREAMING_APP'][0]['expires_on'],
//         lastInvoiceDate: json['VIDEO_STREAMING_APP'][0]['last_invoice_date'],
//         lastInvoicePlan: json['VIDEO_STREAMING_APP'][0]['last_invoice_plan'],
//         lastInvoiceAmount: json['VIDEO_STREAMING_APP'][0]
//             ['last_invoice_amount'],
//         msg: json['VIDEO_STREAMING_APP'][0]['msg'],
//         success: json['VIDEO_STREAMING_APP'][0]['success'],
//         videoStreamingApp:
//             VideoStreamingApp.fromJson(json['VIDEO_STREAMING_APP'][0]),
//       );
// }

// class VideoStreamingApp {
//   int userId;
//   String name;
//   String email;
//   String userImage;
//   String currentPlan;
//   String expiresOn;
//   String lastInvoiceDate;
//   String lastInvoicePlan;
//   String lastInvoiceAmount;
//   String msg;
//   String success;

//   VideoStreamingApp({
//     required this.userId,
//     required this.name,
//     required this.email,
//     required this.userImage,
//     required this.currentPlan,
//     required this.expiresOn,
//     required this.lastInvoiceDate,
//     required this.lastInvoicePlan,
//     required this.lastInvoiceAmount,
//     required this.msg,
//     required this.success,
//   });

//   factory VideoStreamingApp.fromJson(Map<String, dynamic> json) =>
//       VideoStreamingApp(
//         userId: json['user_id'],
//         name: json['name'],
//         email: json['email'],
//         userImage: json['user_image'],
//         currentPlan: json['current_plan'],
//         expiresOn: json['expires_on'],
//         lastInvoiceDate: json['last_invoice_date'],
//         lastInvoicePlan: json['last_invoice_plan'],
//         lastInvoiceAmount: json['last_invoice_amount'],
//         msg: json['msg'],
//         success: json['success'],
//       );
// }
