import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/colors.dart';
import '../search/pages/search_shop.dart';

class PayBill extends StatelessWidget {
  const PayBill({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay'),
      ),
      body: Container(
        width: Get.width,
        height: 350,
        color: Color(0xFF5AA3E8),
        child: Column(
          children: [
            Image.asset(
              'assets/icons/payment/search_shop.png',
              height: 200,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Search The Shop To Pay',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text.rich(
              TextSpan(
                  text: 'Get ',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: 'Extra 25% OFF ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'upto ₹1000',
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 30,
              ),
              child: InkWell(
                onTap: () {
                  Get.to(() => SearchShop());
                },
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    enabled: false,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(AppColors.buttonInactiveColor),
                      hintText: 'Search restaurants, fashions',
                      prefixIcon: SizedBox(
                        width: 20,
                        child: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black26,
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
