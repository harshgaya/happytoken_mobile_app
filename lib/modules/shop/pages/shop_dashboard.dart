import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/authentication/authentication_controller.dart';
import 'package:happy_tokens/modules/shop/controller/shop_controller.dart';
import 'package:happy_tokens/modules/shop/pages/shop_verified_home.dart';

class ShopDashboard extends StatefulWidget {
  const ShopDashboard({super.key});

  @override
  State<ShopDashboard> createState() => _ShopDashboardState();
}

class _ShopDashboardState extends State<ShopDashboard> {
  final shopController = Get.put(ShopController());
  final authController = Get.put(AuthenticationController());
  @override
  void initState() {
    super.initState();
    shopController.checkShopStatus();
  }

  Future<void> _refreshData() async {
    await shopController.checkShopStatus();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Scaffold(
        body: Obx(
          () {
            if (shopController.checkingShopStatus.value) {
              return Center(
                child: Utils.showLoader(),
              );
            }
            if (shopController.shopStatus.value == 'verified') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.off(() => ShopVerifiedHome());
              });
            }
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your shop application',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                await authController.logout();
                              },
                              icon: const Icon(Icons.power_settings_new))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  shopController.shopName.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  shopController.shopCategory.value,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              shopController.shopAddress.value,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFFFAEE),
                                      border: Border.all(color: Colors.yellow)),
                                  child: Text(
                                    shopController.shopStatus.value == 'pending'
                                        ? 'Under Review'
                                        : 'Rejected',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 0.5,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 3,
                                        ),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/icons/shop_details/shop.png',
                                          height: 28,
                                          width: 28,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Container(
                                        height: 50,
                                        width: 5,
                                        color: Colors.grey.shade300,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Shop Information',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF556038),
                                        ),
                                      ),
                                      const Text(
                                        'Name, location and category',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF9293A1),
                                        ),
                                      ),
                                      Text(
                                        shopController.shopStatus.value ==
                                                'pending'
                                            ? 'Under Review'
                                            : 'Rejected',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 3,
                                        ),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/icons/shop_details/document.png',
                                          height: 28,
                                          width: 28,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Container(
                                        height: 50,
                                        width: 5,
                                        color: Colors.grey.shade300,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Shop documents',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF556038),
                                        ),
                                      ),
                                      Text(
                                        shopController.shopStatus.value ==
                                                'pending'
                                            ? 'Under Review'
                                            : 'Rejected',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 3,
                                        ),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/icons/shop_details/verification.png',
                                          height: 28,
                                          width: 28,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Verification',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF556038),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
