import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/sharedprefs.dart';
import 'package:happy_tokens/modules/shop/models/settlement_model.dart';
import 'package:happy_tokens/network/url_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/network_api_services.dart';
import '../../user/models/transaction_model.dart';

class ShopController extends GetxController {
  final _apiServices = NetworkApiServices();
  RxBool checkingShopStatus = false.obs;
  RxString shopStatus = ''.obs;
  RxString shopCategory = ''.obs;
  RxString shopName = ''.obs;
  RxString shopAddress = ''.obs;

  ///payment
  RxBool loadingUserDetails = false.obs;
  RxBool loadingTransaction = false.obs;
  RxBool paying = false.obs;

  RxBool loadingSettlements = false.obs;
  RxList<SettlementData> settlements = <SettlementData>[].obs;
  RxString settlementTotalAmount = '0'.obs;
  RxString settlementTotalDiscount = '0'.obs;
  RxString settlementTotalPlatformFee = '0'.obs;
  int settlementPage = 0;

  int transactionPage = 0;
  RxList<TransactionData> transactions = <TransactionData>[].obs;

  RxDouble walletBalance = 0.0.obs;
  RxString orderId = ''.obs;

  RxString todayTime = "".obs;
  RxString todayTotalAmount = "0".obs;
  RxString todayTotalSuccessfulTransaction = "0".obs;
  RxString todayTotalFailedTransaction = "0".obs;
  RxString todayTotalPendingTransaction = "0".obs;
  RxString todayTotalDiscountAmount = "0".obs;

  RxString lifetimeTotalAmount = "0".obs;
  RxString lifetimeTotalSuccessfulTransaction = "0".obs;
  RxString lifetimeTotalFailedTransaction = "0".obs;
  RxString lifetimeTotalPendingTransaction = "0".obs;
  RxString lifetimeTotalDiscountAmount = "0".obs;

  RxString datetime = 'Select Date'.obs;
  RxString totalSuccessfulTrans = "0".obs;
  RxString totalFailedTrans = "0".obs;
  RxString totalPendingTrans = "0".obs;
  RxString totalAmount = "0".obs;
  RxString totalAmountWithDiscount = "0".obs;

  RxList<FlSpot> monthlyAmounts = <FlSpot>[].obs;

  ///payment

  ///help
  RxString helpMobileNo = ''.obs;
  RxString helpEmail = ''.obs;
  RxString helpWhatsapp = ''.obs;

  ///help
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
          '${item['shop_number']}, ${item['floor']} ${item['area']}, ${item['city']}';

      checkingShopStatus.value = false;
    } catch (e) {
      checkingShopStatus.value = false;
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
          '${UrlConstants.getShopTransactions}/$userId/$transactionPage');
      TransactionModel transactionModel =
          TransactionModel.fromJson(json: response);
      transactions.addAll(transactionModel.data);

      loadingTransaction.value = false;
    } catch (e) {
      loadingTransaction.value = false;
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
      var data = {
        "user_id": userId,
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

  Future<void> getTodayTransactions() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);

      var response = await _apiServices
          .getApi('${UrlConstants.getTodayTransactions}/$userId');
      todayTime.value = response['data']['today_time'];
      todayTotalAmount.value = response['data']['total_amount'].toString();
      todayTotalFailedTransaction.value =
          response['data']['failed_transactions'].toString();
      todayTotalSuccessfulTransaction.value =
          response['data']['successful_transactions'].toString();
      todayTotalFailedTransaction.value =
          response['data']['failed_transactions'].toString();
      todayTotalPendingTransaction.value =
          response['data']['pending_transactions'].toString();
      todayTotalDiscountAmount.value =
          response['data']['total_discount_amount'].toString();
    } catch (e) {}
  }

  Future<void> getLifetimeTransactions() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);

      var response = await _apiServices
          .getApi('${UrlConstants.getLifetimeTransactions}/$userId');
      todayTime.value = response['data']['today_time'];
      lifetimeTotalAmount.value = response['data']['total_amount'].toString();
      lifetimeTotalFailedTransaction.value =
          response['data']['failed_transactions'].toString();
      lifetimeTotalSuccessfulTransaction.value =
          response['data']['successful_transactions'].toString();
      lifetimeTotalFailedTransaction.value =
          response['data']['failed_transactions'].toString();
      lifetimeTotalPendingTransaction.value =
          response['data']['pending_transactions'].toString();
      lifetimeTotalDiscountAmount.value =
          response['data']['total_discount_amount'].toString();
    } catch (e) {}
  }

  Future<void> getDatewiseTransactions({required String date}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);

      var response = await _apiServices
          .getApi('${UrlConstants.getDatewiseTransactions}/$userId/$date');
      print(
        'res ${response}',
      );
      datetime.value = response['data']['date_time'];
      totalAmount.value = response['data']['total_amount'].toString();
      totalPendingTrans.value =
          response['data']['pending_transactions'].toString();
      totalFailedTrans.value =
          response['data']['failed_transactions'].toString();
      totalSuccessfulTrans.value =
          response['data']['successful_transactions'].toString();
      totalAmountWithDiscount.value =
          response['data']['total_discount_amount'].toString();
    } catch (e) {}
  }

  Future<void> getMonthlyTransactions() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);

      var response = await _apiServices
          .getApi('${UrlConstants.getMonthlyTransactions}/$userId');

      for (var monthData in response['data']) {
        monthlyAmounts.add(FlSpot(
          (monthData['month'] as num).toDouble() - 1,
          double.tryParse(monthData['total_amount'].toString()) ?? 0.0,
        ));
      }
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> getSettlements() async {
    try {
      if (loadingSettlements.value) return;
      settlementPage++;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.userId);

      loadingSettlements.value = true;
      var response = await _apiServices
          .getApi('${UrlConstants.getShopSettlements}/$userId/$settlementPage');

      SettlementModel settlementModel =
          SettlementModel.fromJson(json: response);
      settlementTotalAmount.value = settlementModel.totalAmount;
      settlementTotalDiscount.value = settlementModel.totalDiscount;
      settlementTotalPlatformFee.value = settlementModel.platformFee;
      settlements.addAll(settlementModel.data);

      loadingSettlements.value = false;
    } catch (e) {
      print('error $e');
      loadingSettlements.value = false;
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
        "collection": "shop",
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
