import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/user/controller/user_controller.dart';
import 'package:happy_tokens/modules/user/models/shop_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/colors.dart';
import '../../../../helpers/sharedprefs.dart';

class PaymentMethod extends StatefulWidget {
  final ShopData shopData;
  final int totalAmountEntered;

  const PaymentMethod({
    super.key,
    required this.shopData,
    required this.totalAmountEntered,
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
        (widget.totalAmountEntered * widget.shopData.discount) / 100;
    cashbackAmount =
        (widget.totalAmountEntered * widget.shopData.cashback) / 100;
    discountAmount =
        (widget.totalAmountEntered * widget.shopData.discount) / 100;
    amountPaidByPg = widget.totalAmountEntered -
        (widget.totalAmountEntered * widget.shopData.discount) / 100;
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
      shopName: widget.shopData.shopName,
      shopLocation: '${widget.shopData.area}, ${widget.shopData.city}',
      totalAmountWithoutDiscount: widget.totalAmountEntered,
      totalAmountWithDiscount: totalAmountWithDiscount,
      cashbackAmount: cashbackAmount,
      discountAmount: discountAmount,
      discountPercent: widget.shopData.discount,
      cashbackPercent: widget.shopData.cashback,
      razorpayOrderId: orderId!,
      amountPaidByPg: amountPaidByPg,
      amountPaidByWallet: amountPaidUsingWallet,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    userController.checkRazorpayPaymentStatus(
      context: context,
      shopId: widget.shopData.id,
      shopName: widget.shopData.shopName,
      shopLocation: '${widget.shopData.area}, ${widget.shopData.city}',
      totalAmountWithoutDiscount: widget.totalAmountEntered,
      totalAmountWithDiscount: totalAmountWithDiscount,
      cashbackAmount: cashbackAmount,
      discountAmount: discountAmount,
      discountPercent: widget.shopData.discount,
      cashbackPercent: widget.shopData.cashback,
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
        title: const Text(
          'Payment Method',
          style: TextStyle(fontSize: 18),
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
                      color: Color(0xFFB2BDAF),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Payable Amount After Discount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B1C1B),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.shopData.shopName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF010101),
                              ),
                            ),
                            Text(
                              '₹${totalAmountWithDiscount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF010101),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (userController.walletBalance.value != 0 &&
                      totalAmountWithDiscount <=
                          userController.walletBalance.value)
                    ListTile(
                      title: const Text("Pay Using Wallet Balance"),
                      leading: Radio<String>(
                        value: "Wallet",
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                            amountPaidUsingWallet = totalAmountWithDiscount;
                            amountPaidByPg = 0;
                          });
                        },
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wallet Balance :₹${userController.walletBalance.value.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                              '₹${totalAmountWithDiscount.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  if (userController.walletBalance.value != 0 &&
                      totalAmountWithDiscount >
                          userController.walletBalance.value)
                    ListTile(
                      title: Text(
                          "Pay Partial Amount (Wallet:${userController.walletBalance.value.toStringAsFixed(2)})"),
                      leading: Radio<String>(
                        value: "PayPartialOnly",
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                            amountPaidUsingWallet =
                                userController.walletBalance.value;
                            amountPaidByPg = totalAmountWithDiscount -
                                userController.walletBalance.value;
                          });
                        },
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '₹${totalAmountWithDiscount.toStringAsFixed(2)}'),
                          Text(
                              'pay only ₹${(totalAmountWithDiscount - userController.walletBalance.value).toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ListTile(
                    title: const Text("Pay Full Amount"),
                    leading: Radio<String>(
                      value: "PayOnly",
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                          amountPaidUsingWallet = 0;
                          amountPaidByPg = totalAmountWithDiscount;
                        });
                      },
                    ),
                    subtitle:
                        Text('₹${totalAmountWithDiscount.toStringAsFixed(2)}'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                          gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.blue,
                                Colors.blueAccent,
                              ])),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Disclaimer!!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Please do not close the app or switch screens until the payment is completed.',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.2,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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

                                        await userController.payByWallet(
                                          context: context,
                                          shopId: widget.shopData.id,
                                          shopName: widget.shopData.shopName,
                                          shopLocation:
                                              "${widget.shopData.area}, ${widget.shopData.city}",
                                          totalAmountWithoutDiscount:
                                              widget.totalAmountEntered,
                                          totalAmountWithDiscount:
                                              totalAmountWithDiscount,
                                          cashbackAmount: cashbackAmount,
                                          discountAmount: discountAmount,
                                          discountPercent:
                                              widget.shopData.discount,
                                          cashbackPercent:
                                              widget.shopData.cashback,
                                        );
                                      } else if (_selectedOption == 'PayOnly') {
                                        amountPaidUsingWallet = 0;
                                        try {
                                          orderId = await userController
                                              .generateOrderId(
                                            amount: totalAmountWithDiscount,
                                            shopId: widget.shopData.id,
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
                                                widget.shopData.discount,
                                            cashbackPercent:
                                                widget.shopData.cashback,
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
                                            amount: totalAmountWithDiscount -
                                                userController
                                                    .walletBalance.value,
                                            shopId: widget.shopData.id,
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
                                                widget.shopData.discount,
                                            cashbackPercent:
                                                widget.shopData.cashback,
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
                                      padding:
                                          EdgeInsets.only(top: 3, bottom: 3),
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
