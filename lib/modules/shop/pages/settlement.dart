import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/shop/controller/shop_controller.dart';
import 'package:happy_tokens/modules/shop/widgets/settlement_box.dart';
import 'package:happy_tokens/modules/shop/widgets/settlement_tile.dart';

import '../widgets/stack_tile.dart';

class Settlement extends StatefulWidget {
  const Settlement({super.key});

  @override
  State<Settlement> createState() => _SettlementState();
}

class _SettlementState extends State<Settlement> {
  final shopController = Get.put(ShopController());
  final scrollController = ScrollController();

  @override
  void initState() {
    shopController.settlements.value = [];
    shopController.settlementPage = 0;
    shopController.getSettlements();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        shopController.getSettlements();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBE6E6),
      body: Obx(() {
        return Column(
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settlements',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 90,
                  left: (Get.width / 2) - ((Get.width - 30) / 2),
                  child: SettlementBox(
                    text1: "Total Paid",
                    text2: '₹${shopController.settlementTotalAmount.value}',
                    text3: '',
                    text4: '₹${shopController.settlementTotalAmount.value}',
                    text5: 'Total Amount',
                    text6: '₹${shopController.settlementTotalDiscount.value}',
                    text7: 'Total Discount Amount',
                    text8:
                        '₹${shopController.settlementTotalPlatformFee.value}',
                    text9: 'Platform Fee',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 170,
            ),
            Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: shopController.settlements.length,
                  itemBuilder: (context, index) {
                    final item = shopController.settlements[index];
                    return SettlementTile(
                      paidAtDate: Utils.timeToIst(timestamp: item.createdAt),
                      totalTransactions: item.totalTransactions,
                      paidForDate: item.paidForDate,
                      amountPaid: item.totalAmount,
                      totalDiscount: item.totalDiscount,
                      platformFee: item.platformFee,
                      transactionNumber: item.transactionNo ?? '',
                    );
                  }),
            ),
            if (shopController.loadingSettlements.value)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      }),
    );
  }
}
