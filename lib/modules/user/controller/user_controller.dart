import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/sharedprefs.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/user/models/notification_model.dart';
import 'package:happy_tokens/modules/user/models/transaction_model.dart';
import 'package:happy_tokens/modules/user/pages/dashboard.dart';
import 'package:happy_tokens/modules/user/pages/payment/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/network_api_services.dart';
import '../../../network/url_constants.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/shop_model.dart';
import 'dart:io';

class UserController extends GetxController {
  final _apiServices = NetworkApiServices();

  ///notification
  RxBool loadingNotification = false.obs;

  int notificationPage = 0;
  RxList<NotificationData> notifications = <NotificationData>[].obs;
  RxInt unreadNotifications = 0.obs;

  ///notification

  ///help
  RxString helpMobileNo = ''.obs;
  RxString helpEmail = ''.obs;
  RxString helpWhatsapp = ''.obs;

  ///help

  ///payment
  RxBool loadingUserDetails = false.obs;
  RxBool loadingTransaction = false.obs;
  RxBool paying = false.obs;

  int transactionPage = 0;
  RxList<TransactionData> transactions = <TransactionData>[].obs;

  RxDouble walletBalance = 0.0.obs;
  RxString orderId = ''.obs;

  ///payment

  ///banners and categories
  RxList<BannerData> banners = <BannerData>[].obs;
  RxList<CategoryData> category = <CategoryData>[].obs;
  RxBool categoryLoading = false.obs;
  RxBool bannerLoading = false.obs;
  RxBool categoryShopsLoading = false.obs;
  RxList<ShopData> categoryShops = <ShopData>[].obs;

  ///banners and categories

  /// shops
  RxBool loadingVerifiedShops = false.obs;
  RxList<ShopData> verifiedShops = <ShopData>[].obs;
  RxBool searchShopLoading = false.obs;
  RxList<ShopData> searchShopList = <ShopData>[].obs;

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

  Future<void> getCategoryShops({categoryName}) async {
    try {
      if (categoryShopsLoading.value) return;
      categoryShopsLoading.value = true;
      var response = await _apiServices
          .getApi('${UrlConstants.getCategoryShops}/$categoryName');
      ShopModel shopModel = ShopModel.fromJson(json: response);
      categoryShops.addAll(shopModel.data);
      categoryShopsLoading.value = false;
    } catch (e) {
      print('error $e');
      categoryShopsLoading.value = false;
    }
  }

  Future<void> getSearchShops({search}) async {
    try {
      if (searchShopLoading.value) return;
      searchShopList.value = [];
      searchShopLoading.value = true;
      var response =
          await _apiServices.getApi('${UrlConstants.getSearchShop}/$search');
      ShopModel shopModel = ShopModel.fromJson(json: response);
      searchShopList.addAll(shopModel.data);
      searchShopLoading.value = false;
    } catch (e) {
      searchShopList.value = [];
      searchShopLoading.value = false;
    }
  }

  Future<void> getUserDetails() async {
    try {
      if (loadingUserDetails.value) return;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);

      loadingUserDetails.value = true;
      var response =
          await _apiServices.getApi('${UrlConstants.getUserDetails}/$userId');
      walletBalance.value =
          double.tryParse(response['data'][0]['wallet1_balance'].toString())!;

      loadingUserDetails.value = false;
    } catch (e) {
      print('error ${e}');
      loadingUserDetails.value = false;
    }
  }

  Future<void> getTransactions() async {
    try {
      if (loadingTransaction.value) return;
      transactionPage++;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);

      loadingTransaction.value = true;
      var response = await _apiServices.getApi(
          '${UrlConstants.getUserTransactions}/$userId/$transactionPage');
      TransactionModel transactionModel =
          TransactionModel.fromJson(json: response);
      transactions.addAll(transactionModel.data);

      loadingTransaction.value = false;
    } catch (e) {
      loadingTransaction.value = false;
    }
  }

  Future<void> payByWallet({
    required BuildContext context,
    required String shopId,
    required String shopName,
    required String shopLocation,
    required dynamic totalAmountWithoutDiscount,
    required dynamic totalAmountWithDiscount,
    required dynamic cashbackAmount,
    required dynamic discountAmount,
    required dynamic discountPercent,
    required dynamic cashbackPercent,
  }) async {
    try {
      if (paying.value) return;
      paying.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);
      String? userMobile =
          sharedPreferences.getString(SharedPreferenceKey.mobile);
      String? userName = sharedPreferences.getString(SharedPreferenceKey.name);
      var data = {
        "user_id": userId,
        "shop_id": shopId,
        "user_mobile": userMobile,
        "user_name": userName,
        "shop_name": shopName,
        "shop_location": shopLocation,
        "total_amount_without_discount": totalAmountWithoutDiscount,
        "total_amount_with_discount": totalAmountWithDiscount,
        "cashback_amount": cashbackAmount,
        "discount_amount": discountAmount,
        "paid_by": userId,
        "discount_percent": discountPercent,
        "cashback_percent": cashbackPercent,
        "amount_paid_by_pg": 0,
        "amount_paid_by_wallet": totalAmountWithDiscount,
        "razorpay_order_id": "",
        "razorpay_payment_id": "",
        "razorpay_signature": ""
      };
      await _apiServices.postApi(data, UrlConstants.payUsingWallet);
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.offAll(() => Dashboard());

        // Delay before navigating to Transactions to ensure Dashboard is displayed first
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.to(() => const Transactions(
                autoSelectFirst: true,
              ));
        });
      });
      paying.value = false;
    } catch (e) {
      paying.value = false;
      Utils.showSnackBarError(context: context, title: 'Something went wrong!');
    }
  }

  Future<String?> generateOrderId({required dynamic amount}) async {
    try {
      if (paying.value) return '';
      paying.value = true;

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);
      String? mobileNumber =
          sharedPreferences.getString(SharedPreferenceKey.mobile);
      String? userMobile =
          sharedPreferences.getString(SharedPreferenceKey.mobile);
      String? userName = sharedPreferences.getString(SharedPreferenceKey.name);
      loadingTransaction.value = true;
      var data = {
        "amount": amount.toStringAsFixed(0),
        "user_id": userId,
        "user_mobile": userMobile,
        "user_name": userName,
        "mobile_number": mobileNumber
      };
      var response = await _apiServices.postApi(
        data,
        UrlConstants.generateOrderId,
      );
      String orderIdV = response['data']['id'];
      orderId.value = orderIdV;
      paying.value = false;
      return orderIdV;
    } catch (e) {
      paying.value = false;
    }
  }

  Future<void> checkRazorpayPaymentStatus(
      {required BuildContext context,
      required String shopId,
      required String shopName,
      required String shopLocation,
      required dynamic totalAmountWithoutDiscount,
      required dynamic totalAmountWithDiscount,
      required dynamic cashbackAmount,
      required dynamic discountAmount,
      required dynamic discountPercent,
      required dynamic cashbackPercent,
      required String razorpayOrderId,
      required dynamic amountPaidByPg,
      required dynamic amountPaidByWallet}) async {
    try {
      EasyLoading.show(status: 'Checking payment', dismissOnTap: false);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);
      String? userMobile =
          sharedPreferences.getString(SharedPreferenceKey.mobile);
      String? userName = sharedPreferences.getString(SharedPreferenceKey.name);
      print('razorpya order id $razorpayOrderId');
      var data = {
        "user_id": userId,
        "user_mobile": userMobile,
        "user_name": userName,
        "shop_id": shopId,
        "shop_name": shopName,
        "shop_location": shopLocation,
        "total_amount_without_discount": totalAmountWithoutDiscount,
        "total_amount_with_discount": totalAmountWithDiscount,
        "cashback_amount": cashbackAmount,
        "discount_amount": discountAmount,
        "paid_by": userId,
        "discount_percent": discountPercent,
        "cashback_percent": cashbackPercent,
        "amount_paid_by_pg": amountPaidByPg,
        "amount_paid_by_wallet": amountPaidByWallet,
        "razorpay_order_id": razorpayOrderId,
        "razorpay_payment_id": "",
        "razorpay_signature": ""
      };
      await _apiServices.postApi(data, UrlConstants.checkPaymentStatus);
      EasyLoading.dismiss();

      Future.delayed(const Duration(milliseconds: 100), () {
        Get.offAll(() => const Dashboard());

        // Delay before navigating to Transactions to ensure Dashboard is displayed first
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.to(() => const Transactions(
                autoSelectFirst: true,
              ));
        });
      });
    } catch (e) {
      print('errror $e');
      EasyLoading.dismiss();
      Utils.showSnackBarError(context: context, title: 'Something went wrong!');
    }
  }

  Future<bool> recheckPaymentStatus(
      {required BuildContext context,
      required String shopId,
      required String shopName,
      required String shopLocation,
      required dynamic totalAmountWithoutDiscount,
      required dynamic totalAmountWithDiscount,
      required dynamic cashbackAmount,
      required dynamic discountAmount,
      required dynamic discountPercent,
      required dynamic cashbackPercent,
      required String razorpayOrderId,
      required dynamic amountPaidByPg,
      required dynamic amountPaidByWallet}) async {
    try {
      EasyLoading.show(status: 'Checking payment', dismissOnTap: false);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);
      String? userMobile =
          sharedPreferences.getString(SharedPreferenceKey.mobile);
      String? userName = sharedPreferences.getString(SharedPreferenceKey.name);
      var data = {
        "user_id": userId,
        "shop_id": shopId,
        "user_mobile": userMobile,
        "user_name": userName,
        "shop_name": shopName,
        "shop_location": shopLocation,
        "total_amount_without_discount": totalAmountWithoutDiscount,
        "total_amount_with_discount": totalAmountWithDiscount,
        "cashback_amount": cashbackAmount,
        "discount_amount": discountAmount,
        "paid_by": userId,
        "discount_percent": discountPercent,
        "cashback_percent": cashbackPercent,
        "amount_paid_by_pg": amountPaidByPg,
        "amount_paid_by_wallet": amountPaidByWallet,
        "razorpay_order_id": razorpayOrderId,
        "razorpay_payment_id": "",
        "razorpay_signature": ""
      };
      var response =
          await _apiServices.postApi(data, UrlConstants.checkPaymentStatus);
      EasyLoading.dismiss();
      if (response['payment_status']) {
        int index = transactions.indexWhere(
          (t) => t.razorpayOrderId == razorpayOrderId,
        );

        if (index != -1) {
          transactions[index].paymentStatus = 'success';
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      EasyLoading.dismiss();
      return false;
    }
  }

  Future<void> getHelp() async {
    try {
      var response = await _apiServices.getApi('${UrlConstants.getHelp}');
      print('response, ${response['data']['email']}');
      helpEmail.value = response['data']['email'];
      helpMobileNo.value = response['data']['mobile'];
      helpWhatsapp.value = response['data']['whatsapp'];
    } catch (e) {}
  }

  Future<void> getNotifications() async {
    try {
      if (loadingNotification.value) return;
      notificationPage++;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);

      loadingNotification.value = true;
      var response = await _apiServices
          .getApi('${UrlConstants.getNotification}/$userId/$notificationPage');

      NotificationModel notificationModel =
          NotificationModel.fromJson(json: response);
      notifications.addAll(notificationModel.data);
      unreadNotifications.value = notificationModel.unreadNotifications;

      loadingNotification.value = false;
    } catch (e) {
      print('error $e');
      loadingNotification.value = false;
    }
  }

  Future<void> updateDeviceToken() async {
    try {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);
      String? token = await firebaseMessaging.getToken();
      var data = {
        "id": userId,
        "collection": "users",
        "device_token": token ?? ""
      };
      var response =
          await _apiServices.postApi(data, UrlConstants.updateDeviceToken);
      print("Device Token: $token");
    } catch (e) {
      print('unable to update device token');
    }
  }
}
