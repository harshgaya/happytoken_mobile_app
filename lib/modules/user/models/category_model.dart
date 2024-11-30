class CategoryModel {
  int status;
  String message;
  List<CategoryData> data;

  CategoryModel(
      {required this.status, required this.message, required this.data});
  factory CategoryModel.fromJson({required Map<String, dynamic> json}) =>
      CategoryModel(
        status: json['status'],
        message: json['message'],
        data: List<CategoryData>.from(
          json['data'].map(
            (x) => CategoryData.fromJson(json: x),
          ),
        ),
      );
}

class CategoryData {
  String id;
  String name;
  String image;

  CategoryData({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryData.fromJson({required Map<String, dynamic> json}) =>
      CategoryData(id: json['_id'], name: json['name'], image: json['image']);
}
