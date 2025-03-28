class BannerModel {
  int status;
  String message;
  List<BannerData> data;
  BannerModel(
      {required this.data, required this.message, required this.status});
  factory BannerModel.fromJson({required Map<String, dynamic> json}) =>
      BannerModel(
          data: List<BannerData>.from(
            json['data'].map(
              (x) => BannerData.fromJson(json: x),
            ),
          ),
          message: json['message'],
          status: json['status']);
}

class BannerData {
  String id;
  String image;
  BannerData({required this.id, required this.image});
  factory BannerData.fromJson({required Map<String, dynamic> json}) =>
      BannerData(id: json['_id'], image: json['image']);
}
