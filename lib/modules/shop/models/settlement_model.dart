class SettlementModel {
  int status;
  String message;
  String totalAmount;
  String totalDiscount;
  String platformFee;

  List<SettlementData> data;
  SettlementModel(
      {required this.data,
      required this.message,
      required this.status,
      required this.platformFee,
      required this.totalDiscount,
      required this.totalAmount});
  factory SettlementModel.fromJson({required Map<String, dynamic> json}) =>
      SettlementModel(
          data: List<SettlementData>.from(
            json['data'].map(
              (x) => SettlementData.fromJson(json: x),
            ),
          ),
          message: json['message'],
          totalAmount: json['totalAmount'].toString(),
          totalDiscount: json['totalDiscount'].toString(),
          platformFee: json['platformFee'].toString(),
          status: json['status']);
}

class SettlementData {
  String id;
  String totalAmount;
  String paidForDate;
  String totalDiscount;
  String platformFee;
  String createdAt;
  String totalTransactions;
  String? transactionNo;

  SettlementData({
    required this.id,
    required this.totalAmount,
    required this.paidForDate,
    required this.totalDiscount,
    required this.platformFee,
    required this.createdAt,
    required this.totalTransactions,
    required this.transactionNo,
  });

  factory SettlementData.fromJson({required Map<String, dynamic> json}) =>
      SettlementData(
          id: json['_id'],
          totalAmount: json['totalAmount'].toString(),
          paidForDate: json['date'].toString(),
          totalDiscount: json['totalDiscount'].toString(),
          platformFee: json['platform_fee'].toString(),
          createdAt: json['created_at'].toString(),
          totalTransactions: json['total_transactions'].toString(),
          transactionNo: json['utr_number'] ?? "");
}
