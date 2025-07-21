class ShopModel {
  int status;
  String message;
  List<ShopData> data;

  ShopModel({required this.status, required this.message, required this.data});
  factory ShopModel.fromJson({required Map<String, dynamic> json}) => ShopModel(
        status: json['status'],
        message: json['message'],
        data: List<ShopData>.from(
          json['data'].map(
            (x) => ShopData.fromJson(json: x),
          ),
        ),
      );
}

class ShopData {
  String id;
  String shopName;
  String status;
  String mobileNumber;
  String categoryName;
  String panCardImage;
  String createdDate;
  String bankAccountNumber;
  int commission;
  String shopImage;
  String gstNumber;
  String ownerName;
  String ownerEmail;
  String categoryId;
  double latitude;
  double longitude;
  String shopNo;
  String floor;
  String area;
  String city;
  String state;
  String landmark;
  dynamic discount;
  dynamic cashback;
  dynamic extraDiscount;
  dynamic extraCashback;
  Map<String, dynamic>? shopTimings;
  ShopData({
    required this.id,
    this.shopTimings,
    required this.shopName,
    required this.mobileNumber,
    required this.shopImage,
    required this.categoryName,
    required this.landmark,
    required this.state,
    required this.city,
    required this.status,
    required this.cashback,
    required this.discount,
    required this.area,
    required this.floor,
    required this.longitude,
    required this.latitude,
    required this.categoryId,
    required this.ownerEmail,
    required this.ownerName,
    required this.createdDate,
    required this.gstNumber,
    required this.bankAccountNumber,
    required this.commission,
    required this.panCardImage,
    required this.shopNo,
    this.extraDiscount,
    this.extraCashback,
  });

  factory ShopData.fromJson({required Map<String, dynamic> json}) => ShopData(
        id: json['_id'],
        shopName: json['shop_name'],
        shopTimings: json['shop_timings'] ?? {},
        mobileNumber: json['mobile_number'],
        shopImage: json['shop_image'],
        categoryName: json['category_name'],
        discount: json['discount'],
        cashback: json['cashback'],
        landmark: json['shop_address']['landmark'] ?? '',
        state: json['shop_address']['state'] ?? '',
        city: json['shop_address']['city'] ?? '',
        area: json['shop_address']['area'] ?? '',
        floor: json['shop_address']['floor'] ?? '',
        longitude: json['shop_address']['longitude'] ?? '',
        latitude: json['shop_address']['latitude'] ?? '',
        shopNo: json['shop_address']['shop_number'] ?? '',
        categoryId: json['category_id'],
        ownerEmail: json['owner_email'],
        ownerName: json['owner_name'],
        createdDate: json['created_date'],
        gstNumber: json['_id'],
        bankAccountNumber: json['bankaccount_number'],
        commission: json['commission'],
        panCardImage: json['pan_card_image'],
        status: json['status'],
        extraCashback: json['extra_cashback'] ?? 0,
        extraDiscount: json['extra_discount'] ?? 0,
      );
}
