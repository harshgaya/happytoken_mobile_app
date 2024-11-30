import 'package:get/get.dart';

import '../../../network/network_api_services.dart';
import '../../../network/url_constants.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/shop_model.dart';

class UserController extends GetxController {
  final _apiServices = NetworkApiServices();

  ///banners and categories
  RxList<BannerData> banners = <BannerData>[].obs;
  RxList<CategoryData> category = <CategoryData>[].obs;
  RxBool categoryLoading = false.obs;
  RxBool bannerLoading = false.obs;

  ///banners and categories

  /// shops
  RxBool loadingVerifiedShops = false.obs;
  RxList<ShopData> verifiedShops = <ShopData>[].obs;

  /// shops

  ///banners and categories
  Future<void> getBanners() async {
    try {
      bannerLoading.value = true;
      banners.value = [];
      var response = await _apiServices.getApi(UrlConstants.getAllBanners);
      BannerModel bannerModel = BannerModel.fromJson(json: response);
      banners.addAll(bannerModel.data);
      bannerLoading.value = false;
    } catch (e) {
      bannerLoading.value = false;
      print('error $e');
    }
  }

  Future<void> getCategory() async {
    try {
      categoryLoading.value = true;
      category.value = [];
      var response = await _apiServices.getApi(UrlConstants.getAllCategory);
      CategoryModel categoryModel = CategoryModel.fromJson(json: response);
      category.addAll(categoryModel.data);
      categoryLoading.value = false;
    } catch (e) {
      categoryLoading.value = false;
      print('error $e');
    }
  }

  Future<void> getVerifiedShops() async {
    try {
      if (loadingVerifiedShops.value) return;
      loadingVerifiedShops.value = true;
      var response =
          await _apiServices.getApi('${UrlConstants.getVerifiedShops}/1');
      ShopModel shopModel = ShopModel.fromJson(json: response);
      verifiedShops.addAll(shopModel.data);
      loadingVerifiedShops.value = false;
    } catch (e) {
      print('error $e');
      loadingVerifiedShops.value = false;
    }
  }
}
