import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/colors.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/user/models/shop_model.dart';
import 'package:happy_tokens/modules/user/pages/payment/payment_summary.dart';
import 'package:happy_tokens/modules/user/pages/payment/widgets/restaurant_offer.dart';
import 'package:url_launcher/url_launcher.dart';

class EnterAmountScreen extends StatefulWidget {
  final ShopData shopData;
  const EnterAmountScreen({
    super.key,
    required this.shopData,
  });

  @override
  State<EnterAmountScreen> createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  final billAmountController = TextEditingController();
  bool isWalletSelected = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: Column(
          children: [
            Hero(
              tag: 'shop',
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Image container
                  Container(
                    height: 300,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.shopData.shopImage),
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    height: 300,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 10,
                    child: Text(
                      widget.shopData.shopName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 45,
                    left: 10,
                    child: Text(
                      '${widget.shopData.area}, ${widget.shopData.city}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                      child: Text(
                        Utils.getTodayShopStatus(widget.shopData.shopTimings!),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Utils.getTodayShopStatus(
                                      widget.shopData.shopTimings!)
                                  .contains('Closed')
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -15,
                    right: 10,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            String googleUrl =
                                'https://www.google.com/maps/dir/?api=1&destination=${widget.shopData.latitude.toString()},${widget.shopData.longitude.toString()}';
                            Uri uri = Uri.parse(googleUrl);

                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              throw 'Could not open the map.';
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                )
                              ],
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.directions),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            final Uri uri = Uri.parse(
                                'tel:${widget.shopData.mobileNumber}');

                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              throw 'Could not launch ';
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                )
                              ],
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.call),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8F2),
                  border: Border.all(color: const Color(0xFFFFD3AC)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RestaurantOffer(
                        restaurantOffer: widget.shopData.commission),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              '₹',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                              ),
                              child: TextFormField(
                                controller: billAmountController,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.black,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Bill Amount',
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (widget.shopData.shopName
                                  .toLowerCase()
                                  .contains('test')) {
                                Utils.showSnackBarError(
                                    context: context,
                                    title: 'You cannot pay to test shop');
                                return;
                              }
                              if (billAmountController.text.isEmpty ||
                                  int.tryParse(billAmountController.text) ==
                                      0) {
                                Utils.showSnackBarError(
                                    context: context,
                                    title: 'Bill amount is not correct');
                              } else {
                                Get.to(() => PaymentSummary(
                                      shopData: widget.shopData,
                                      billAmount: int.tryParse(
                                          billAmountController.text)!,
                                    ));
                              }
                            },
                            child: Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(AppColors.appMainColor),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Center(
                                child: Text(
                                  'Pay Bill',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
