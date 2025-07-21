import 'dart:async';
import 'dart:typed_data';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
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
  RxString pancardNumber = ''.obs;
  RxString gstNumber = ''.obs;
  RxString businessType = ''.obs;
  RxString shopName = ''.obs;
  RxMap storeTimings = {}.obs;
  RxString tradeName = ''.obs;
  RxString categoryName = ''.obs;
  RxString categoryId = ''.obs;
  RxString shopOwnerName = ''.obs;
  RxString showOwnerEmail = ''.obs;
  RxString referredBy = ''.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString city = ''.obs;
  RxString state = ''.obs;
  RxString shopNumber = ''.obs;
  RxString pincode = ''.obs;
  RxString floor = ''.obs;
  RxString area = ''.obs;
  RxString landmark = ''.obs;
  RxString bankAccount = ''.obs;
  RxString bankAccountName = ''.obs;
  RxString bankName = ''.obs;
  RxString bankBranchName = ''.obs;
  RxString bankIFSCCode = ''.obs;
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
          context: context, title: 'OTP sent successfully.');
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
          context: context, title: 'OTP sent successfully.');
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
      var data = {"mobile": mobile, "otp": otp, "sessionId": sessionId.value};
      var response = await _apiServices.postApi(data, UrlConstants.verifyOtp);
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
      var data = {"mobile": mobile, "otp": otp, "sessionId": sessionId.value};
      otpVerifying.value = true;
      var response =
          await _apiServices.postApi(data, '${UrlConstants.verifyOtpShop}');
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
    required String referredBy,
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var data = {
        "id": sharedPreferences.getString(SharedPreferenceKey.userId),
        "name": name,
        "referred_by": referredBy
      };

      addingName.value = true;
      var response = await _apiServices.postApi(data, UrlConstants.addNameNew);
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

    if (Platform.isIOS) {
      Get.offAll(const UserState());
    } else {
      await FirebaseMessaging.instance.deleteToken();
      FirebaseMessaging.instance.unsubscribeFromTopic("happy-tokens");
      Get.offAll(const UserState());
    }
  }

  Future<void> deleteAccount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await _apiServices.getApi(
        '${UrlConstants.deleteAccount}/${sharedPreferences.getString(SharedPreferenceKey.userId)}');
    await sharedPreferences.remove(SharedPreferenceKey.name);
    await sharedPreferences.remove(SharedPreferenceKey.mobile);
    await sharedPreferences.remove(SharedPreferenceKey.userId);
    await sharedPreferences.remove(SharedPreferenceKey.jwtToken);
    await sharedPreferences.remove(SharedPreferenceKey.login);
    await sharedPreferences.remove(SharedPreferenceKey.userType);
    await sharedPreferences.remove(SharedPreferenceKey.shopStatus);

    if (Platform.isIOS) {
      Get.offAll(const UserState());
    } else {
      await FirebaseMessaging.instance.deleteToken();
      FirebaseMessaging.instance.unsubscribeFromTopic("happy-tokens");
      Get.offAll(const UserState());
    }
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

  // Future<void> addShopDetails(
  //     {required Uint8List restaurantImage,
  //     required Uint8List panImage,
  //     required Uint8List bankPassbook,
  //     Uint8List? gstImage,
  //     Uint8List? businessImage,
  //     required BuildContext context}) async {
  //   try {
  //     addingShopDetails.value = true;
  //     SharedPreferences sharedPreferences =
  //         await SharedPreferences.getInstance();
  //
  //     Map<String, Future<String>> uploadTasks = {};
  //     uploadTasks.add(
  //       Utils.uploadFileToCloudFlare(
  //           fileBytes: restaurantImage,
  //           isVideo: false,
  //           context: context,
  //           path: 'RestaurantImages',
  //           onProgress: (va) {}),
  //     );
  //     uploadTasks.add(
  //       Utils.uploadFileToCloudFlare(
  //           fileBytes: panImage,
  //           isVideo: false,
  //           context: context,
  //           path: 'PANImages',
  //           onProgress: (va) {}),
  //     );
  //     uploadTasks.add(Utils.uploadFileToCloudFlare(
  //         fileBytes: bankPassbook,
  //         isVideo: false,
  //         context: context,
  //         path: 'BankPassbookImage',
  //         onProgress: (va) {}));
  //     if (gstImage != null) {
  //       uploadTasks.add(Utils.uploadFileToCloudFlare(
  //           fileBytes: gstImage,
  //           isVideo: false,
  //           context: context,
  //           path: 'gstImages',
  //           onProgress: (va) {}));
  //     }
  //     if (businessImage != null) {
  //       uploadTasks.add(Utils.uploadFileToCloudFlare(
  //           fileBytes: businessImage,
  //           isVideo: false,
  //           context: context,
  //           path: 'businessImages',
  //           onProgress: (va) {}));
  //     }
  //
  //     List images = await Future.wait(uploadTasks).catchError((error) {
  //       Utils.showSnackBarError(
  //           context: context, title: 'Error uploading image');
  //       addingShopDetails.value = false;
  //     });
  //
  //     var data = {
  //       "id": sharedPreferences.getString(SharedPreferenceKey.userId),
  //       "shop_name": shopName.value,
  //       "shop_timings": storeTimings,
  //       "category_name": categoryName.value,
  //       "category_id": categoryId.value,
  //       "pan_card_number": pancardNumber.value,
  //       "pan_card_image": images[1],
  //       "gst_image":
  //       "business_type": businessType.value,
  //       "bankaccount_number": bankAccount.value,
  //       "bankaccount_image": images[2],
  //       "owner_name": shopOwnerName.value,
  //       "owner_email": showOwnerEmail.value,
  //       "latitude": latitude.value,
  //       "trade_name": tradeName.value,
  //       "bank_account_name": bankAccountName.value,
  //       "bank_name": bankName.value,
  //       "bank_branch_name": bankBranchName.value,
  //       "bank_ifsc_code": bankIFSCCode.value,
  //       "longitude": longitude.value,
  //       "shop_number": shopNumber.value,
  //       "floor": floor.value,
  //       "pincode": pincode.value,
  //       "area": area.value,
  //       "city": city.value,
  //       "state": state.value,
  //       "landmark": landmark.value,
  //       "shop_image": images[0],
  //       "commission": cashbackToCustomer.value
  //     };
  //     var response =
  //         await _apiServices.postApi(data, UrlConstants.addShopDetails);
  //     sharedPreferences.setString(SharedPreferenceKey.name, shopName.value);
  //     Get.offAll(() => const UserState());
  //   } catch (e) {
  //     addingShopDetails.value = false;
  //   }
  // }
  Future<void> addShopDetails({
    required Uint8List restaurantImage,
    required Uint8List panImage,
    required Uint8List bankPassbook,
    Uint8List? gstImage,
    Uint8List? businessImage,
    required BuildContext context,
  }) async {
    try {
      addingShopDetails.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      Map<String, Future<String>> uploadTasks = {
        "shop_image": Utils.uploadFileToCloudFlare(
          fileBytes: restaurantImage,
          isVideo: false,
          context: context,
          path: 'shopImages',
          onProgress: (va) {},
        ),
        "pan_card_image": Utils.uploadFileToCloudFlare(
          fileBytes: panImage,
          isVideo: false,
          context: context,
          path: 'PANImages',
          onProgress: (va) {},
        ),
        "bankaccount_image": Utils.uploadFileToCloudFlare(
          fileBytes: bankPassbook,
          isVideo: false,
          context: context,
          path: 'BankPassbookImage',
          onProgress: (va) {},
        ),
      };

      if (gstImage != null) {
        uploadTasks["gst_image"] = Utils.uploadFileToCloudFlare(
          fileBytes: gstImage,
          isVideo: false,
          context: context,
          path: 'gstImages',
          onProgress: (va) {},
        );
      }

      if (businessImage != null) {
        uploadTasks["business_image"] = Utils.uploadFileToCloudFlare(
          fileBytes: businessImage,
          isVideo: false,
          context: context,
          path: 'businessImages',
          onProgress: (va) {},
        );
      }

      Map<String, String> uploadedImages = {};
      await Future.wait(uploadTasks.entries.map((entry) async {
        uploadedImages[entry.key] = await entry.value;
      })).catchError((error) {
        Utils.showSnackBarError(
            context: context, title: 'Error uploading image');
        addingShopDetails.value = false;
      });

      var data = {
        "id": sharedPreferences.getString(SharedPreferenceKey.userId),
        "shop_name": shopName.value,
        "shop_timings": storeTimings,
        "category_name": categoryName.value,
        "referred_by": referredBy.value,
        "category_id": categoryId.value,
        "pan_card_number": pancardNumber.value,
        "pan_card_image": uploadedImages["pan_card_image"],
        "gst_number": gstNumber.value,
        "gst_image": uploadedImages["gst_image"],
        "business_type": businessType.value,
        "business_image": uploadedImages['business_image'],
        "bankaccount_number": bankAccount.value,
        "bankaccount_image": uploadedImages["bankaccount_image"],
        "owner_name": shopOwnerName.value,
        "owner_email": showOwnerEmail.value,
        "latitude": latitude.value,
        "trade_name": tradeName.value,
        "bank_account_name": bankAccountName.value,
        "bank_name": bankName.value,
        "bank_branch_name": bankBranchName.value,
        "bank_ifsc_code": bankIFSCCode.value,
        "longitude": longitude.value,
        "shop_number": shopNumber.value,
        "floor": floor.value,
        "pincode": pincode.value,
        "area": area.value,
        "city": city.value,
        "state": state.value,
        "landmark": landmark.value,
        "shop_image": uploadedImages["shop_image"],
        "commission": cashbackToCustomer.value,
      };

      print('gst number ${gstNumber.value}');
      var response =
          await _apiServices.postApi(data, UrlConstants.addShopDetails);
      sharedPreferences.setString(SharedPreferenceKey.name, shopName.value);
      addingShopDetails.value = false;
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
