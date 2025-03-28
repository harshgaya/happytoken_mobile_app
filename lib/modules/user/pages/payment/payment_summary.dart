import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/colors.dart';
import 'package:happy_tokens/modules/user/models/shop_model.dart';
import 'package:happy_tokens/modules/user/pages/payment/payment_methods.dart';
import 'package:happy_tokens/modules/user/pages/payment/widgets/carousal_payment.dart';
import 'package:super_tooltip/super_tooltip.dart';

class PaymentSummary extends StatefulWidget {
  final ShopData shopData;
  final int billAmount;

  const PaymentSummary({
    super.key,
    required this.billAmount,
    required this.shopData,
  });

  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  final _controller = SuperTooltipController();

  void makeTooltip() {
    _controller.showTooltip();
  }

  void hideToolTip() {
    _controller.hideTooltip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2BDAF),
        title: Text(
          'Paying to ${widget.shopData.shopName}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          const CarousalPayment(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey)),
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
                        '₹${widget.billAmount}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                        'Instant Discount ${widget.shopData.discount}%',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      Text(
                        '₹${(widget.billAmount * (widget.shopData.discount / 100)).toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      )
                    ],
                  ),
                  // if (widget.shopData.discount > 1)
                  const SizedBox(
                    height: 8,
                  ),
                  // if (widget.shopData.discount > 1)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // 'Surprise Cashback ${widget.shopData.cashback}%',
                        'Surprise Cashback 1-10%',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      Text(
                        '',
                        // '₹${(widget.billAmount * widget.shopData.cashback / 100).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Convenience Fee',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF616161),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _controller.showTooltip();
                            },
                            child: SuperTooltip(
                              showBarrier: true,
                              popupDirection: TooltipDirection.up,
                              backgroundColor: Colors.white,
                              controller: _controller,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Convenience Fee',
                                        style: TextStyle(
                                          color: Color(0xFF4E4E4E),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: hideToolTip,
                                        child: const Icon(
                                          Icons.close,
                                          size: 15,
                                          color: Color(0xFF4E4E4E),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'This fee helps us support effective operations and constant platform betterment, for a trouble-free service.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF5E5B5C),
                                    ),
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Color(0xFF616161),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        '₹0',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF616161),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Dash(
                    direction: Axis.horizontal,
                    length: Get.width - 60,
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
                        'You Pay',
                        style: TextStyle(),
                      ),
                      Text(
                        '₹${double.tryParse(widget.billAmount.toString())! - (widget.billAmount * widget.shopData.discount / 100)}',
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Text(
            '**Hey, You are eligible for weekly surprise cash back entry.',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(AppColors.appMainColor),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5.0), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => PaymentMethod(
                              shopData: widget.shopData,
                              totalAmountEntered: widget.billAmount,
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3, bottom: 3),
                        child: Column(
                          children: [
                            const Text(
                              'Select Payment Option',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${double.tryParse(widget.billAmount.toString())! - (widget.billAmount * (widget.shopData.discount) / 100)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
