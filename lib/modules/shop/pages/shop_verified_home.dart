import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/authentication/authentication_controller.dart';
import 'package:happy_tokens/modules/shop/controller/shop_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../user/controller/user_controller.dart';

class ShopVerifiedHome extends StatefulWidget {
  const ShopVerifiedHome({super.key});

  @override
  State<ShopVerifiedHome> createState() => _ShopVerifiedHomeState();
}

class _ShopVerifiedHomeState extends State<ShopVerifiedHome> {
  final authController = Get.put(AuthenticationController());
  final userController = Get.put(UserController());
  final shopController = Get.put(ShopController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.getBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              shopController.shopName.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        Text(
                          shopController.shopAddress.value,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: () async {
                        await authController.logout();
                      },
                      icon: const Icon(Icons.power_settings_new),
                    ),
                  ],
                ),
                Obx(
                  () => userController.bannerLoading.value
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            direction: ShimmerDirection.ltr,
                            period: const Duration(seconds: 2),
                            child: Container(
                              width: Get.width,
                              height: 130,
                              color: Colors
                                  .grey[300], // This will be the base shape
                            ),
                          ),
                        )
                      : CarouselSlider(
                          items: userController.banners
                              .map((e) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Image.network(e.image),
                                  ))
                              .toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                          )),
                ),
                const Text(
                  'Quick Links',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 80,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                )
                              ]),
                          child: Icon(
                            Icons.currency_rupee,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'My Payouts',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          height: 80,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                )
                              ]),
                          child: const Icon(
                            Icons.help_outline,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Help Center',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
