import 'package:get/get.dart';
import 'package:happy_tokens/helpers/sharedprefs.dart';
import 'package:happy_tokens/network/url_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/network_api_services.dart';

class ShopController extends GetxController {
  final _apiServices = NetworkApiServices();
  RxBool checkingShopStatus = false.obs;
  RxString shopStatus = ''.obs;
  RxString shopCategory = ''.obs;
  RxString shopName = ''.obs;
  RxString shopAddress = ''.obs;

  Future<void> checkShopStatus() async {
    try {
      checkingShopStatus.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var response = await _apiServices.getApi(
          '${UrlConstants.checkShopStatus}/${sharedPreferences.getString(SharedPreferenceKey.userId)}');
      shopStatus.value = response['data'][0]['status'];
      shopCategory.value = response['data'][0]['category_name'];
      shopName.value = response['data'][0]['shop_name'];
      var item = response['data'][0]['shop_address'];
      shopAddress.value =
          '${item['shop_number']}, ${item['floor']} ${item['area']}, ${item['city']}, ${item['state']}';

      checkingShopStatus.value = false;
    } catch (e) {
      checkingShopStatus.value = false;
    }
  }
}
