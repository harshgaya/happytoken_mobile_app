import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/authentication/pages/login_screen.dart';
import 'package:happy_tokens/modules/authentication/pages/onboarding_screen.dart';
import 'package:happy_tokens/modules/authentication/pages/otp_screen.dart';
import 'package:happy_tokens/modules/authentication/pages/otp_screen_shop.dart';
import 'package:happy_tokens/modules/authentication/pages/shop_details.dart';
import 'package:happy_tokens/modules/authentication/pages/user_details.dart';
import 'package:happy_tokens/modules/authentication/pages/user_state.dart';
import 'package:happy_tokens/modules/shop/pages/shop_dashboard.dart';
import 'package:happy_tokens/modules/user/pages/dashboard.dart';
import 'package:happy_tokens/network/url_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/sharedprefs.dart';
import '../../helpers/utils.dart';
import '../../network/network_api_services.dart';
import '../user/models/category_model.dart';

class AuthenticationController extends GetxController {
  Timer? timer;
  RxInt start = 20.obs;
  RxBool otpSending = false.obs;
  RxBool otpVerifying = false.obs;
  RxString sessionId = ''.obs;
  RxBool addingName = false.obs;

  RxList<CategoryData> category = <CategoryData>[].obs;

  ///shop details
  RxString shopName = ''.obs;
  RxString categoryName = ''.obs;
  RxString categoryId = ''.obs;
  RxString shopOwnerName = ''.obs;
  RxString showOwnerEmail = ''.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString city = ''.obs;
  RxString state = ''.obs;
  RxString shopNumber = ''.obs;
  RxString floor = ''.obs;
  RxString area = ''.obs;
  RxString landmark = ''.obs;
  RxString bankAccount = ''.obs;
  RxInt cashbackToCustomer = 0.obs;

  RxBool addingShopDetails = false.obs;

  ///shop details

  final _apiServices = NetworkApiServices();
  checkSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? onboard = sharedPreferences.getBool(SharedPreferenceKey.onboard);
    bool? login = sharedPreferences.getBool(SharedPreferenceKey.login);
    String? token = sharedPreferences.getString(SharedPreferenceKey.jwtToken);
    String? name = sharedPreferences.getString(SharedPreferenceKey.name);
    String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);
    String? mobile = sharedPreferences.getString(SharedPreferenceKey.mobile);
    String? userType =
        sharedPreferences.getString(SharedPreferenceKey.userType);
    print('${onboard} ${login} ${token} ${name} ${userId} ${mobile}');

    if (onboard == null || onboard == false) {
      return Get.offAll(() => const OnBoardingScreen());
    }
    if (token == null || token.isEmpty) {
      return Get.offAll(() => const LoginScreen());
    }
    if (userId == null || userId.isEmpty) {
      return Get.offAll(() => const LoginScreen());
    }

    if (login == null || login == false) {
      return Get.offAll(() => const LoginScreen());
    }
    if (userType == 'user') {
      if (name == null || name.isEmpty) {
        return Get.offAll(UserDetails(mobile: mobile ?? ''));
      }
    }
    if (userType == 'shop') {
      if (name == null || name.isEmpty) {
        return Get.offAll(() => ShopDetails());
      } else {
        return Get.offAll(() => ShopDashboard());
      }
    }

    if (userType == 'user') {
      return Get.offAll(() => const Dashboard());
    }
    return Get.offAll(() => const ShopDashboard());
  }

  saveSharedPrefOnboard() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(SharedPreferenceKey.onboard, true);
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      update();
      if (start.value <= 0) {
        timer.cancel();
      } else {
        start.value -= 1;
      }
    });
  }

  Future<void> sendOtp(
      {required String mobile, required BuildContext context}) async {
    try {
      otpSending.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var response =
          await _apiServices.getApi('${UrlConstants.sendOtp}/${mobile}');
      sharedPreferences.setString(
          SharedPreferenceKey.jwtToken, response['data'][0]['token']);
      sharedPreferences.setString(
          SharedPreferenceKey.userId, response['data'][0]['user_id']);
      sharedPreferences.setString(
          SharedPreferenceKey.name, response['data'][0]['name']);

      otpSending.value = false;
      Get.to(() => OtpScreen(
            mobileNumber: mobile,
            name: response['data'][0]['name'],
          ));
      sessionId.value = response['data'][0]['sessionId'];
      Utils.showSnackBarSuccess(
          context: context, title: 'OTP sent successfully');
    } catch (e) {
      otpSending.value = false;
      print('error $e');
      Utils.showSnackBarError(context: context, title: 'Something went wrong');
    }
  }

  Future<void> sendOtpShop(
      {required String mobile, required BuildContext context}) async {
    try {
      otpSending.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var response =
          await _apiServices.getApi('${UrlConstants.sendOtpShop}/${mobile}');
      sharedPreferences.setString(
          SharedPreferenceKey.jwtToken, response['data'][0]['token']);
      sharedPreferences.setString(
          SharedPreferenceKey.userId, response['data'][0]['shop_id']);

      sharedPreferences.setString(
          SharedPreferenceKey.shopStatus, response['data'][0]['status']);
      sharedPreferences.setString(
          SharedPreferenceKey.name, response['data'][0]['shop_name']);

      otpSending.value = false;
      Get.to(() => OtpScreenShop(
            mobileNumber: mobile,
            name: response['data'][0]['shop_name'],
          ));
      sessionId.value = response['data'][0]['sessionId'];
      Utils.showSnackBarSuccess(
          context: context, title: 'OTP sent successfully');
    } catch (e) {
      otpSending.value = false;
      print('error $e');
      Utils.showSnackBarError(context: context, title: 'Something went wrong');
    }
  }

  Future<void> verifyOtp({
    required String otp,
    required BuildContext context,
    required String mobile,
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      otpVerifying.value = true;
      var response = await _apiServices
          .getApi('${UrlConstants.verifyOtp}/${sessionId.value}/${otp}');
      otpVerifying.value = false;
      Utils.showSnackBarSuccess(
          context: context, title: 'OTP verified successfully');
      sharedPreferences.setString(SharedPreferenceKey.mobile, mobile);
      sharedPreferences.setBool(SharedPreferenceKey.login, true);
      sharedPreferences.setString(SharedPreferenceKey.userType, 'user');
      Get.offAll(() => const UserState());
    } catch (e) {
      otpVerifying.value = false;
      print('error $e');
      Utils.showSnackBarError(context: context, title: 'OTP incorrect');
    }
  }

  Future<void> verifyOtpShop({
    required String otp,
    required BuildContext context,
    required String mobile,
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      otpVerifying.value = true;
      var response = await _apiServices
          .getApi('${UrlConstants.verifyOtpShop}/${sessionId.value}/${otp}');
      otpVerifying.value = false;
      Utils.showSnackBarSuccess(
          context: context, title: 'OTP verified successfully');
      sharedPreferences.setString(SharedPreferenceKey.mobile, mobile);
      sharedPreferences.setBool(SharedPreferenceKey.login, true);
      sharedPreferences.setString(SharedPreferenceKey.userType, 'shop');
      Get.offAll(() => const UserState());
    } catch (e) {
      otpVerifying.value = false;
      print('error $e');
      Utils.showSnackBarError(context: context, title: 'OTP incorrect');
    }
  }

  Future<void> addName({
    required String name,
    required BuildContext context,
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      addingName.value = true;
      var response = await _apiServices.getApi(
          '${UrlConstants.addName}/${sharedPreferences.getString(SharedPreferenceKey.userId)}/${name}');
      addingName.value = false;
      sharedPreferences.setString(SharedPreferenceKey.name, name);
      Get.offAll(() => const UserState());
    } catch (e) {
      addingName.value = false;
      print('error $e');
      Utils.showSnackBarError(context: context, title: 'OTP incorrect');
    }
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(SharedPreferenceKey.name);
    await sharedPreferences.remove(SharedPreferenceKey.mobile);
    await sharedPreferences.remove(SharedPreferenceKey.userId);
    await sharedPreferences.remove(SharedPreferenceKey.jwtToken);
    await sharedPreferences.remove(SharedPreferenceKey.login);
    await sharedPreferences.remove(SharedPreferenceKey.userType);
    await sharedPreferences.remove(SharedPreferenceKey.shopStatus);
    Get.offAll(const UserState());
  }

  Future<void> getCategory() async {
    try {
      category.value = [];
      var response = await _apiServices.getApi(UrlConstants.getAllCategory);
      CategoryModel categoryModel = CategoryModel.fromJson(json: response);
      category.addAll(categoryModel.data);
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> addShopDetails(
      {required Uint8List restaurantImage,
      required Uint8List panImage,
      required BuildContext context}) async {
    try {
      addingShopDetails.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      List<String> images = await Future.wait([
        Utils.uploadFileToCloudFlare(
            fileBytes: restaurantImage,
            isVideo: false,
            context: context,
            path: 'RestaurantImages',
            onProgress: (va) {}),
        Utils.uploadFileToCloudFlare(
            fileBytes: panImage,
            isVideo: false,
            context: context,
            path: 'PANImages',
            onProgress: (va) {})
      ]).catchError((error) {
        Utils.showSnackBarError(
            context: context, title: 'Error uploading image');
        addingShopDetails.value = false;
      });

      var data = {
        "id": sharedPreferences.getString(SharedPreferenceKey.userId),
        "shop_name": shopName.value,
        "category_name": categoryName.value,
        "category_id": categoryId.value,
        "pan_card_number": "",
        "pan_card_image": images[1],
        "bankaccount_number": bankAccount.value,
        "bankaccount_image": "fer",
        "owner_name": shopOwnerName.value,
        "owner_email": showOwnerEmail.value,
        "latitude": latitude.value,
        "longitude": longitude.value,
        "shop_number": shopNumber.value,
        "floor": floor.value,
        "area": area.value,
        "city": city.value,
        "state": state.value,
        "landmark": landmark.value,
        "shop_image": images[0],
        "commission": cashbackToCustomer.value
      };
      var response =
          await _apiServices.postApi(data, UrlConstants.addShopDetails);
      sharedPreferences.setString(SharedPreferenceKey.name, shopName.value);
      Get.offAll(() => const UserState());
    } catch (e) {
      addingShopDetails.value = false;
    }
  }

  Future<void> checkShopStatus({required BuildContext context}) async {
    try {} catch (e) {
      Utils.showSnackBarError(context: context, title: 'Error uploading image');
    }
  }
}
