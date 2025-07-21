class WalletTransactionModel {
  int status;
  String message;
  List<WalletTransactionData> data;
  WalletTransactionModel(
      {required this.data, required this.message, required this.status});
  factory WalletTransactionModel.fromJson(
          {required Map<String, dynamic> json}) =>
      WalletTransactionModel(
          data: List<WalletTransactionData>.from(
            json['data'].map(
              (x) => WalletTransactionData.fromJson(json: x),
            ),
          ),
          message: json['message'],
          status: json['status']);
}

class WalletTransactionData {
  String id;
  String userId;
  bool? paidToShop;
  String? message;
  dynamic amount;
  String date;

  WalletTransactionData({
    required this.id,
    this.amount,
    this.message,
    this.paidToShop,
    required this.userId,
    required this.date,
  });

  factory WalletTransactionData.fromJson(
          {required Map<String, dynamic> json}) =>
      WalletTransactionData(
          id: json['_id'],
          userId: json['user_id'],
          date: json['created_at'],
          paidToShop: json['paid_to_shop'],
          message: json['message'],
          amount: json['amount']);
}
