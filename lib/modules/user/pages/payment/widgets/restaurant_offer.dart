import 'package:flutter/material.dart';

import '../../../../../helpers/utils.dart';

class RestaurantOffer extends StatelessWidget {
  final int restaurantOffer;
  const RestaurantOffer({super.key, required this.restaurantOffer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 5,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saving on Bill',
            style: TextStyle(
              color: Color(0xFFCC4600),
              fontSize: 13,
            ),
          ),
          Text(
            Utils.getDiscountRange(double.parse(restaurantOffer.toString())),
            // 'Discount & Cashback upto $restaurantOffer%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
