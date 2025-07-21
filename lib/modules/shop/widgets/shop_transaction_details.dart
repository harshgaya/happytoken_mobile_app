import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/shop/controller/shop_controller.dart';
import 'package:happy_tokens/modules/user/controller/user_controller.dart';
import 'package:happy_tokens/modules/user/models/transaction_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopTransactionDetails extends StatefulWidget {
  final TransactionData transactionData;
  const ShopTransactionDetails({
    super.key,
    required this.transactionData,
  });

  @override
  State<ShopTransactionDetails> createState() => _ShopTransactionDetailsState();
}

class _ShopTransactionDetailsState extends State<ShopTransactionDetails> {
  final shopController = Get.put(ShopController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              if (widget.transactionData.paymentStatus == 'success')
                Image.asset(
                  'assets/icons/payment/success.png',
                  height: 80,
                ),
              if (widget.transactionData.paymentStatus == 'pending')
                Image.asset(
                  'assets/icons/payment/waiting.png',
                  height: 80,
                ),
              if (widget.transactionData.paymentStatus == 'failed')
                Image.asset(
                  'assets/icons/payment/failed.png',
                  height: 80,
                ),
              const SizedBox(
                height: 10,
              ),
              if (widget.transactionData.paymentStatus == 'success')
                const Text('Payment Success'),
              if (widget.transactionData.paymentStatus == 'waiting')
                const Text('Payment Processing'),
              if (widget.transactionData.paymentStatus == 'failed')
                const Text('Payment Failed!'),
              const SizedBox(
                height: 10,
              ),
              Text(
                '₹${widget.transactionData.totalAmountWithoutDiscount}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (widget.transactionData.paymentStatus != 'success')
                Container(
                  color: const Color(0xFFF5F5F5),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 30),
                        child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            text:
                                "No worries! If your money was deducted, it'll be refunded within ",
                            children: [
                              TextSpan(
                                text: '5 working days',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          bool paymentStatus =
                              await shopController.recheckPaymentStatus(
                            context: context,
                            shopId: widget.transactionData.shopId,
                            shopName: widget.transactionData.shopName,
                            shopLocation: widget.transactionData.shopLocation,
                            totalAmountWithoutDiscount: widget
                                .transactionData.totalAmountWithoutDiscount,
                            totalAmountWithDiscount:
                                widget.transactionData.totalAmountWithDiscount,
                            cashbackAmount:
                                widget.transactionData.cashbackAmount,
                            discountAmount:
                                widget.transactionData.discountAmount,
                            discountPercent:
                                widget.transactionData.discountPercent,
                            cashbackPercent:
                                widget.transactionData.cashbackPercent,
                            razorpayOrderId:
                                widget.transactionData.razorpayOrderId,
                            amountPaidByPg:
                                widget.transactionData.amountPaidByPg,
                            amountPaidByWallet:
                                widget.transactionData.amountPaidByWallet,
                          );
                          if (paymentStatus) {
                            setState(() {
                              widget.transactionData.paymentStatus = 'success';
                            });
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Color(0xFF4A90E2),
                            ),
                            Text(
                              'Check payment status',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color(0xFF4A90E2),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 50, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Paid By ${widget.transactionData.userName ?? ""}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        Utils.maskedMobile(widget.transactionData.userMobile),
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF616161)),
                      ),
                      Text(
                        Utils.timeToIst(
                            timestamp: widget.transactionData.createdAt),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Transaction ID: ${widget.transactionData.id}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Payment Summary')),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF5F5F5)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bill Amount',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₹${widget.transactionData.totalAmountWithoutDiscount}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Instant Discount ${widget.transactionData.discountPercent}%',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Text(
                            '₹${widget.transactionData.discountAmount}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // const Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Text(
                      //           'Convenience Fee',
                      //           style: TextStyle(
                      //             fontSize: 14,
                      //             color: Color(0xFF616161),
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           width: 3,
                      //         ),
                      //       ],
                      //     ),
                      //     Text(
                      //       '₹0',
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         color: Color(0xFF616161),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 8,
                      // ),
                      Dash(
                        direction: Axis.horizontal,
                        length: Get.width - 40,
                        dashLength: 3,
                        dashColor: Colors.grey,
                        dashThickness: 2,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Paid by Customer',
                            style: TextStyle(),
                          ),
                          Text(
                            '₹${widget.transactionData.totalAmountWithDiscount.toStringAsFixed(2)}',
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // if (widget.transactionData.paymentStatus != 'success')
              //   Padding(
              //     padding: const EdgeInsets.only(left: 10, right: 10),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         OutlinedButton(
              //           onPressed: () async {
              //             final uri = Uri.parse(
              //                 'tel:${shopController.helpMobileNo.value}');
              //             if (await canLaunchUrl(uri)) {
              //               await launchUrl(uri);
              //             } else {
              //               print('Could not launch $uri');
              //             }
              //           },
              //           style: OutlinedButton.styleFrom(
              //             side: const BorderSide(
              //                 color: Color(0xFF4A90E2),
              //                 width: 1), // Border color and width
              //             shape: RoundedRectangleBorder(
              //               borderRadius:
              //                   BorderRadius.circular(5), // Border radius
              //             ),
              //           ),
              //           child: const Text(
              //             'Call Concierge',
              //             style: TextStyle(
              //               color: Color(0xFF4A90E2),
              //               fontWeight: FontWeight.w400,
              //             ),
              //           ),
              //         ),
              //         OutlinedButton(
              //           onPressed: () async {
              //             bool paymentStatus =
              //                 await shopController.recheckPaymentStatus(
              //               context: context,
              //               shopId: widget.transactionData.shopId,
              //               shopName: widget.transactionData.shopName,
              //               shopLocation: widget.transactionData.shopLocation,
              //               totalAmountWithoutDiscount: widget
              //                   .transactionData.totalAmountWithoutDiscount,
              //               totalAmountWithDiscount:
              //                   widget.transactionData.totalAmountWithDiscount,
              //               cashbackAmount:
              //                   widget.transactionData.cashbackAmount,
              //               discountAmount:
              //                   widget.transactionData.discountAmount,
              //               discountPercent:
              //                   widget.transactionData.discountPercent,
              //               cashbackPercent:
              //                   widget.transactionData.cashbackPercent,
              //               razorpayOrderId:
              //                   widget.transactionData.razorpayOrderId,
              //               amountPaidByPg:
              //                   widget.transactionData.amountPaidByPg,
              //               amountPaidByWallet:
              //                   widget.transactionData.amountPaidByWallet,
              //             );
              //             if (paymentStatus) {
              //               setState(() {
              //                 widget.transactionData.paymentStatus = 'success';
              //               });
              //             }
              //           },
              //           style: OutlinedButton.styleFrom(
              //             side: const BorderSide(
              //                 color: Color(0xFF4A90E2),
              //                 width: 1), // Border color and width
              //             shape: RoundedRectangleBorder(
              //               borderRadius:
              //                   BorderRadius.circular(5), // Border radius
              //             ),
              //           ),
              //           child: const Text(
              //             'Check Status',
              //             style: TextStyle(
              //               color: Color(0xFF4A90E2),
              //               fontWeight: FontWeight.w400,
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
