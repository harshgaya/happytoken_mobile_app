import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/user/controller/user_controller.dart';
import 'package:happy_tokens/modules/user/models/shop_model.dart';
import 'package:happy_tokens/modules/user/pages/payment/widgets/payment_method_tile.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/colors.dart';
import '../../../../helpers/sharedprefs.dart';

class PaymentMethod extends StatefulWidget {
  final ShopData shopData;
  final int extraDiscount;
  final int extraCashback;
  final double extraCashbackAmount;
  final double extraDiscountAmount;
  final int totalAmountEntered;

  const PaymentMethod({
    super.key,
    required this.shopData,
    required this.totalAmountEntered,
    required this.extraDiscount,
    required this.extraCashback,
    required this.extraCashbackAmount,
    required this.extraDiscountAmount,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String _selectedOption = "PayOnly";
  final userController = Get.put(UserController());
  dynamic amountPaidUsingWallet = 0;
  dynamic totalAmountWithDiscount = 0;
  dynamic cashbackAmount = 0;
  dynamic discountAmount = 0;
  dynamic amountPaidByPg = 0;

  @override
  void initState() {
    userController.getUserDetails();
    getUserName();
    calculateAmount();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void calculateAmount() {
    totalAmountWithDiscount = widget.totalAmountEntered -
        (widget.totalAmountEntered * widget.shopData.discount) / 100 -
        widget.extraDiscountAmount;
    cashbackAmount =
        (widget.totalAmountEntered * widget.shopData.cashback) / 100 +
            widget.extraCashbackAmount;
    discountAmount =
        (widget.totalAmountEntered * widget.shopData.discount) / 100 +
            widget.extraDiscountAmount;
    amountPaidByPg = widget.totalAmountEntered -
        (widget.totalAmountEntered * widget.shopData.discount) / 100 -
        widget.extraDiscountAmount;
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  ///razorpay
  late Razorpay _razorpay;
  String? orderId;
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    userController.checkRazorpayPaymentStatus(
      context: context,
      shopId: widget.shopData.id,
      extraCashbackAmount: widget.extraCashbackAmount,
      extraCashbackPercent: widget.extraCashback,
      extraDiscountAmount: widget.extraDiscountAmount,
      extraDiscountPercent: widget.extraDiscount,
      shopName: widget.shopData.shopName,
      shopLocation: '${widget.shopData.area}, ${widget.shopData.city}',
      totalAmountWithoutDiscount: widget.totalAmountEntered,
      totalAmountWithDiscount: totalAmountWithDiscount,
      cashbackAmount: cashbackAmount,
      discountAmount: discountAmount,
      discountPercent: widget.shopData.discount + widget.extraDiscount,
      cashbackPercent: widget.shopData.cashback + widget.extraCashback,
      razorpayOrderId: orderId!,
      amountPaidByPg: amountPaidByPg,
      amountPaidByWallet: amountPaidUsingWallet,
      shopCommission: widget.shopData.commission,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    userController.checkRazorpayPaymentStatus(
      context: context,
      extraCashbackAmount: widget.extraCashbackAmount,
      extraCashbackPercent: widget.extraCashback,
      extraDiscountAmount: widget.extraDiscountAmount,
      extraDiscountPercent: widget.extraDiscount,
      shopId: widget.shopData.id,
      shopCommission: widget.shopData.commission,
      shopName: widget.shopData.shopName,
      shopLocation: '${widget.shopData.area}, ${widget.shopData.city}',
      totalAmountWithoutDiscount: widget.totalAmountEntered,
      totalAmountWithDiscount: totalAmountWithDiscount,
      cashbackAmount: cashbackAmount,
      discountAmount: discountAmount,
      discountPercent: widget.shopData.discount + widget.extraDiscount,
      cashbackPercent: widget.shopData.cashback + widget.extraCashback,
      razorpayOrderId: orderId!,
      amountPaidByPg: amountPaidByPg,
      amountPaidByWallet: amountPaidUsingWallet,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Selected: ${response.walletName}");
    // Handle external wallet selection here
  }

  void openCheckout(
      {required dynamic amount,
      required String shopName,
      required String orderId}) {
    userController.paying.value = true;
    //rzp_live_vQEyzDyrQuagcz
    //
    // manessh api razo rzp_live_Q17zUkAmZ1ELxF
    int roundedAmountInPaise =
        (double.parse(amount.toStringAsFixed(2)) * 100).round();
    var options = {
      'key': 'rzp_live_8zD4EN5LNtRy3H',
      'amount': amount,
      "order_id": orderId,
      'name': 'Happy Tokens By ADPRO',
      'image':
          'https://happy-tokens.s3.ap-south-1.amazonaws.com/Logo+for+Icon+(1).png',
      'description': 'Paying to $shopName',
      'prefill': {
        'contact': mobileNumber,
        'email': 'info@happytokens.in',
      },
      'webview_intent': true,
      'modal': {
        'escape': false,
      },
    };

    try {
      _razorpay.open(options);
      userController.paying.value = false;
    } catch (e) {
      userController.paying.value = false;
      print("Error: $e");
    }
  }

  String? name;
  String? mobileNumber;

  getUserName() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    name = sharedPreferences.getString(SharedPreferenceKey.name);
    mobileNumber = sharedPreferences.getString(SharedPreferenceKey.mobile);
    setState(() {});
  }

  ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(AppColors.appMainColor),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          widget.shopData.shopName,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(
        () => userController.loadingUserDetails.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10),
                    decoration: const BoxDecoration(
                      color: Color(AppColors.appMainColor),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Your Bill',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '₹${(totalAmountWithDiscount).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (userController.walletBalance.value != 0 &&
                      (totalAmountWithDiscount) <=
                          userController.walletBalance.value)
                    PaymentMethodTile(
                      function: (value) {
                        _selectedOption = value;
                        amountPaidUsingWallet = totalAmountWithDiscount;
                        amountPaidByPg = 0;
                        setState(() {});
                      },
                      groupValue: _selectedOption,
                      title: "Pay Using Wallet Balance",
                      amountToPay: totalAmountWithDiscount.toStringAsFixed(2),
                      lastText: 'Amount will be deducted from your wallet',
                      walletBalance:
                          userController.walletBalance.value.toStringAsFixed(2),
                      showWalletBalance: true,
                      radioValue: 'Wallet',
                    ),
                  // ListTile(
                  //   title: const Text("Pay Using Wallet Balance"),
                  //   leading: Radio<String>(
                  //     value: "Wallet",
                  //     groupValue: _selectedOption,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         _selectedOption = value!;
                  //         amountPaidUsingWallet = totalAmountWithDiscount;
                  //         amountPaidByPg = 0;
                  //       });
                  //     },
                  //   ),
                  //   subtitle: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'Wallet Balance :₹${userController.walletBalance.value.toStringAsFixed(2)}',
                  //         style: const TextStyle(
                  //           fontSize: 16,
                  //           color: Colors.green,
                  //         ),
                  //       ),
                  //       Text(
                  //           '₹${(totalAmountWithDiscount).toStringAsFixed(2)}'),
                  //     ],
                  //   ),
                  // ),
                  if (userController.walletBalance.value != 0 &&
                      (totalAmountWithDiscount) >
                          userController.walletBalance.value)
                    PaymentMethodTile(
                      function: (value) {
                        setState(() {
                          _selectedOption = value;
                          amountPaidUsingWallet =
                              userController.walletBalance.value;
                          amountPaidByPg = totalAmountWithDiscount -
                              userController.walletBalance.value;
                        });
                      },
                      groupValue: _selectedOption,
                      title: "Pay Partial Amount",
                      amountToPay: (totalAmountWithDiscount -
                              userController.walletBalance.value)
                          .toStringAsFixed(2),
                      lastText:
                          '₹${userController.walletBalance.value.toStringAsFixed(2)}  will be deducted from your wallet and ₹${(totalAmountWithDiscount - userController.walletBalance.value).toStringAsFixed(2)} will be deducted from other payment method UPI/Card/Net Banking',
                      walletBalance:
                          userController.walletBalance.value.toStringAsFixed(2),
                      showWalletBalance: true,
                      radioValue: 'PayPartialOnly',
                    ),
                  // ListTile(
                  //   title: Text(
                  //       "Pay Partial Amount (Wallet:${userController.walletBalance.value.toStringAsFixed(2)})"),
                  //   leading: Radio<String>(
                  //     value: "PayPartialOnly",
                  //     groupValue: _selectedOption,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         _selectedOption = value!;
                  //         amountPaidUsingWallet =
                  //             userController.walletBalance.value;
                  //         amountPaidByPg = totalAmountWithDiscount -
                  //             userController.walletBalance.value;
                  //       });
                  //     },
                  //   ),
                  //   subtitle: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //           '₹${(totalAmountWithDiscount).toStringAsFixed(2)}'),
                  //       Text(
                  //           'pay only ₹${(totalAmountWithDiscount - userController.walletBalance.value).toStringAsFixed(2)}'),
                  //     ],
                  //   ),
                  // ),

                  PaymentMethodTile(
                    function: (value) {
                      setState(() {
                        _selectedOption = value!;
                        amountPaidUsingWallet = 0;
                        amountPaidByPg = totalAmountWithDiscount;
                      });
                    },
                    groupValue: _selectedOption,
                    title: "Pay Full Amount",
                    amountToPay: totalAmountWithDiscount.toStringAsFixed(2),
                    lastText:
                        'You will pay full amount using other payment method UPI/Card/Net Banking',
                    walletBalance:
                        userController.walletBalance.value.toStringAsFixed(2),
                    showWalletBalance: false,
                    radioValue: 'PayOnly',
                  ),
                  // ListTile(
                  //   title: const Text("Pay Full Amount"),
                  //   leading: Radio<String>(
                  //     value: "PayOnly",
                  //     groupValue: _selectedOption,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         _selectedOption = value!;
                  //         amountPaidUsingWallet = 0;
                  //         amountPaidByPg = totalAmountWithDiscount;
                  //       });
                  //     },
                  //   ),
                  //   subtitle: Text(
                  //       '₹${(totalAmountWithDiscount).toStringAsFixed(2)}'),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Container(
                  //     padding: const EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: Colors.blue,
                  //         gradient: const LinearGradient(
                  //             begin: Alignment.topCenter,
                  //             end: Alignment.bottomCenter,
                  //             colors: [
                  //               Colors.blue,
                  //               Colors.blueAccent,
                  //             ])),
                  //     child: const Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Disclaimer!!',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //             fontSize: 20,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           height: 5,
                  //         ),
                  //         Text(
                  //           'Please do not close the app or switch screens until the payment is completed.',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             height: 1.2,
                  //             fontWeight: FontWeight.w400,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const Spacer(),
                  Obx(() => userController.paying.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 30),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(AppColors.appMainColor),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_selectedOption == 'Wallet') {
                                        if (totalAmountWithDiscount >
                                            userController
                                                .walletBalance.value) {
                                          return Utils.showSnackBarError(
                                              context: context,
                                              title: 'Low Balance');
                                        }
                                        amountPaidUsingWallet =
                                            totalAmountWithDiscount;
                                        Utils.showCustomDialog(
                                            context,
                                            'Are you sure?',
                                            'Want to pay using wallet? Amount will be deducted from wallet.',
                                            () async {
                                          await userController.payByWallet(
                                            context: context,
                                            shopId: widget.shopData.id,
                                            shopName: widget.shopData.shopName,
                                            extraCashbackAmount:
                                                widget.extraCashbackAmount,
                                            extraCashbackPercent:
                                                widget.extraCashback,
                                            extraDiscountAmount:
                                                widget.extraDiscountAmount,
                                            extraDiscountPercent:
                                                widget.extraDiscount,
                                            shopLocation:
                                                "${widget.shopData.area}, ${widget.shopData.city}",
                                            totalAmountWithoutDiscount:
                                                widget.totalAmountEntered,
                                            totalAmountWithDiscount:
                                                totalAmountWithDiscount,
                                            cashbackAmount: cashbackAmount,
                                            discountAmount: discountAmount,
                                            discountPercent:
                                                widget.shopData.discount +
                                                    widget.extraDiscount,
                                            cashbackPercent:
                                                widget.shopData.cashback +
                                                    widget.extraCashback,
                                            shopCommission:
                                                widget.shopData.commission,
                                          );
                                        });
                                      } else if (_selectedOption == 'PayOnly') {
                                        amountPaidUsingWallet = 0;
                                        try {
                                          orderId = await userController
                                              .generateOrderId(
                                            shopCommission:
                                                widget.shopData.commission,
                                            amount: totalAmountWithDiscount,
                                            shopId: widget.shopData.id,
                                            shopName: widget.shopData.shopName,
                                            extraCashbackAmount:
                                                widget.extraCashbackAmount,
                                            extraCashbackPercent:
                                                widget.extraCashback,
                                            extraDiscountAmount:
                                                widget.extraDiscountAmount,
                                            extraDiscountPercent:
                                                widget.extraDiscount,
                                            shopLocation:
                                                '${widget.shopData.area}, ${widget.shopData.city}',
                                            totalAmountWithoutDiscount:
                                                widget.totalAmountEntered,
                                            totalAmountWithDiscount:
                                                totalAmountWithDiscount,
                                            cashbackAmount: cashbackAmount,
                                            discountAmount: discountAmount,
                                            discountPercent:
                                                widget.shopData.discount +
                                                    widget.extraDiscount,
                                            cashbackPercent:
                                                widget.shopData.cashback +
                                                    widget.extraCashback,
                                            amountPaidByPg: amountPaidByPg,
                                            amountPaidByWallet:
                                                amountPaidUsingWallet,
                                          );
                                          if (orderId != null ||
                                              orderId!.isNotEmpty) {
                                            openCheckout(
                                                amount: totalAmountWithDiscount,
                                                shopName:
                                                    widget.shopData.shopName,
                                                orderId: orderId!);
                                          }
                                        } catch (e) {
                                          Utils.showSnackBarError(
                                              context: context,
                                              title: 'Something went wrong');
                                        }
                                      } else {
                                        amountPaidUsingWallet =
                                            amountPaidUsingWallet;
                                        try {
                                          orderId = await userController
                                              .generateOrderId(
                                            shopCommission:
                                                widget.shopData.commission,
                                            amount: totalAmountWithDiscount -
                                                userController
                                                    .walletBalance.value,
                                            shopId: widget.shopData.id,
                                            extraCashbackAmount:
                                                widget.extraCashbackAmount,
                                            extraCashbackPercent:
                                                widget.extraCashback,
                                            extraDiscountAmount:
                                                widget.extraDiscountAmount,
                                            extraDiscountPercent:
                                                widget.extraDiscount,
                                            shopName: widget.shopData.shopName,
                                            shopLocation:
                                                '${widget.shopData.area}, ${widget.shopData.city}',
                                            totalAmountWithoutDiscount:
                                                widget.totalAmountEntered,
                                            totalAmountWithDiscount:
                                                totalAmountWithDiscount,
                                            cashbackAmount: cashbackAmount,
                                            discountAmount: discountAmount,
                                            discountPercent:
                                                widget.shopData.discount +
                                                    widget.extraDiscount,
                                            cashbackPercent:
                                                widget.shopData.cashback +
                                                    widget.extraCashback,
                                            amountPaidByPg: amountPaidByPg,
                                            amountPaidByWallet:
                                                amountPaidUsingWallet,
                                          );
                                          if (orderId != null ||
                                              orderId!.isNotEmpty) {
                                            openCheckout(
                                                amount:
                                                    totalAmountWithDiscount -
                                                        userController
                                                            .walletBalance
                                                            .value,
                                                shopName:
                                                    widget.shopData.shopName,
                                                orderId: orderId!);
                                          }
                                        } catch (e) {
                                          Utils.showSnackBarError(
                                              context: context,
                                              title: 'Something went wrong');
                                        }
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Pay',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ))
                ],
              ),
      ),
    );
  }
}
