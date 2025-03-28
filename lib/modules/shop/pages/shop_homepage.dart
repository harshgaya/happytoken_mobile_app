import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:happy_tokens/modules/shop/pages/graph_transactions.dart';
import 'package:upgrader/upgrader.dart';

import '../../authentication/authentication_controller.dart';
import '../controller/shop_controller.dart';
import '../widgets/stack_tile.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  final shopController = Get.put(ShopController());
  final authController = Get.put(AuthenticationController());

  @override
  void initState() {
    getHomePageData();
    super.initState();
  }

  Future<void> getHomePageData() async {
    Future.wait([
      shopController.getMonthlyTransactions(),
      shopController.getLifetimeTransactions(),
      shopController.getTodayTransactions(),
      shopController.updateDeviceToken(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      barrierDismissible: false,
      showIgnore: false,
      showLater: false,
      child: Obx(() => ListView(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 150,
                    padding: const EdgeInsets.all(10),
                    width: Get.width,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E3478),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  shopController.shopName.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              shopController.shopAddress.value,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            showBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    width: Get.width,
                                    padding: const EdgeInsets.all(8),
                                    color: const Color(0xFF15181F),
                                    height: 330,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              )),
                                        ),
                                        Image.asset(
                                          'assets/icons/account/logout-b.png',
                                          height: 50,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text(
                                          'Are you sure you want to log out?',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          'You will be asked to log in again to view and to pay your favourites shops.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF8D99B5),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF0047D7),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          )),
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    await authController
                                                        .logout();
                                                  },
                                                  child: const Text(
                                                    'Log Out',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Color(0xFF8D98B4)),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.power_settings_new,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: (Get.width / 2) - ((Get.width - 30) / 2),
                    child: Obx(() => StackTile(
                          text1: "Today's Transactions",
                          text2: '₹${shopController.todayTotalAmount.value}',
                          text3: shopController.todayTime.value,
                          text4: shopController
                              .todayTotalSuccessfulTransaction.value,
                          text5: 'Successfull',
                          text6:
                              shopController.todayTotalFailedTransaction.value,
                          text7: 'Failed',
                          text8:
                              shopController.todayTotalPendingTransaction.value,
                          text9: 'Pending',
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 160,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: StackTile(
                  text1: "Lifetime Transactions",
                  text2: '₹${shopController.lifetimeTotalAmount.value}',
                  text3: '',
                  text4:
                      shopController.lifetimeTotalSuccessfulTransaction.value,
                  text5: 'Successfull',
                  text6: shopController.lifetimeTotalFailedTransaction.value,
                  text7: 'Failed',
                  text8: shopController.lifetimeTotalPendingTransaction.value,
                  text9: 'Pending',
                ),
              ),
              Obx(
                () => TransactionsGraphPage(
                  monthlyAmounts: shopController.monthlyAmounts.value,
                ),
              )
            ],
          )),
    );
  }
}
