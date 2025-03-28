import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/user/models/shop_model.dart';
import 'package:happy_tokens/modules/user/pages/payment/enter_amount.dart';

class SearchTile extends StatelessWidget {
  final ShopData shopData;
  const SearchTile({
    super.key,
    required this.shopData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => EnterAmountScreen(
              shopData: shopData,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 20),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                shopData.shopImage,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopData.shopName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/location.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${shopData.area}, ${shopData.city}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF696969)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/percent.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      '10-20% OFF',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFFD95A31)),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
