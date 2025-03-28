class TransactionModel {
  int status;
  String message;
  List<TransactionData> data;
  TransactionModel(
      {required this.data, required this.message, required this.status});
  factory TransactionModel.fromJson({required Map<String, dynamic> json}) =>
      TransactionModel(
          data: List<TransactionData>.from(
            json['data'].map(
              (x) => TransactionData.fromJson(json: x),
            ),
          ),
          message: json['message'],
          status: json['status']);
}

class TransactionData {
  String id;
  String userId;
  String? userName;
  String? userMobile;
  String shopId;
  String shopName;
  String shopLocation;
  dynamic totalAmountWithoutDiscount;
  dynamic totalAmountWithDiscount;
  dynamic cashbackAmount;
  dynamic discountAmount;
  String razorpayOrderId;
  String razorpayPaymentId;
  dynamic amountPaidByPg;
  dynamic amountPaidByWallet;
  dynamic discountPercent;
  dynamic cashbackPercent;
  String createdAt;
  String paymentStatus;

  TransactionData(
      {required this.id,
      this.userName,
      this.userMobile,
      required this.userId,
      required this.shopName,
      required this.shopLocation,
      required this.shopId,
      required this.totalAmountWithoutDiscount,
      required this.totalAmountWithDiscount,
      required this.cashbackAmount,
      required this.discountAmount,
      required this.razorpayOrderId,
      required this.razorpayPaymentId,
      required this.cashbackPercent,
      required this.discountPercent,
      required this.amountPaidByPg,
      required this.amountPaidByWallet,
      required this.createdAt,
      required this.paymentStatus});

  factory TransactionData.fromJson({required Map<String, dynamic> json}) =>
      TransactionData(
          id: json['_id'],
          userId: json['user_id'],
          userName: json['user_name'] ?? '',
          userMobile: json['user_mobile'] ?? '',
          shopName: json['shop_name'] ?? '',
          shopLocation: json['shop_location'] ?? '',
          shopId: json['shop_id'],
          totalAmountWithoutDiscount: json['total_amount_without_discount'],
          totalAmountWithDiscount: json['total_amount_with_discount'],
          cashbackAmount: json['cashback_amount'],
          discountAmount: json['discount_amount'],
          razorpayOrderId: json['razorpay_order_id'],
          razorpayPaymentId: json['razorpay_payment_id'],
          amountPaidByPg: json['amount_paid_by_pg'],
          amountPaidByWallet: json['amount_paid_by_wallet'],
          createdAt: json['created_at'],
          paymentStatus: json['payment_status'],
          cashbackPercent: json['cashback_percent'],
          discountPercent: json['discount_percent']);
}
