import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/user/models/shop_model.dart';

class RestaurantTile extends StatelessWidget {
  final ShopData shopData;
  const RestaurantTile({super.key, required this.shopData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     color: Colors.white,
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.grey.withOpacity(0.3), // Shadow color
        //         spreadRadius: 3, // Spread radius for shadow
        //         blurRadius: 2, // Smooth blur for shadow
        //         offset: Offset(0, 4),
        //       ),
        //     ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.network(
                shopData.shopImage,
                height: 180,
                width: Get.width - 40,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3, left: 5),
              child: Text(
                shopData.shopName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                '${shopData.area}, ${shopData.city}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF696969)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/percent.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      Utils.getDiscountRange(
                          double.parse(shopData.commission.toString())),
                      // '${shopData.commission}% OFF',
                      // 'Save 10-20% on Bill',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFFD95A31)),
                    )
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
