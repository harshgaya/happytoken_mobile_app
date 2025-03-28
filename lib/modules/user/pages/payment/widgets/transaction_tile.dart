import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/user/models/transaction_model.dart';
import 'package:happy_tokens/modules/user/pages/payment/transaction_details.dart';

class TransactionTile extends StatelessWidget {
  final TransactionData transactionData;

  const TransactionTile({
    super.key,
    required this.transactionData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(TransactionDetails(transactionData: transactionData));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: Get.width - 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transactionData.shopName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          transactionData.shopLocation,
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF616161)),
                        ),
                        Text(
                          Utils.timeToIst(timestamp: transactionData.createdAt),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    if (transactionData.paymentStatus == 'success')
                      Image.asset(
                        'assets/icons/payment/success.png',
                        height: 50,
                      ),
                    if (transactionData.paymentStatus == 'pending')
                      Image.asset(
                        'assets/icons/payment/waiting.png',
                        height: 50,
                      ),
                    if (transactionData.paymentStatus == 'failed')
                      Image.asset(
                        'assets/icons/payment/failed.png',
                        height: 50,
                      ),
                  ],
                ),
              ),
              if (transactionData.paymentStatus == 'success')
                Container(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/payment/cashback.png',
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${transactionData.cashbackAmount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const Text(
                            'Cashback Earned',
                            style: TextStyle(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 12, bottom: 12),
                decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (transactionData.paymentStatus == 'success')
                      Text(
                        'Bill Amount ₹${transactionData.totalAmountWithoutDiscount}',
                        style: const TextStyle(color: Color(0xFF45E073)),
                      ),
                    if (transactionData.paymentStatus == 'waiting')
                      Text(
                        'Bill Amount ₹${transactionData.totalAmountWithoutDiscount}',
                        style: const TextStyle(color: Color(0xFFFFCB7F)),
                      ),
                    if (transactionData.paymentStatus == 'failed')
                      Text(
                        'Bill Amount ₹${transactionData.totalAmountWithoutDiscount}',
                        style: const TextStyle(
                          color: Color(0xFFF59A99),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const Text(
                      'View Details >',
                      style: TextStyle(color: Color(0xFF5999E3)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
