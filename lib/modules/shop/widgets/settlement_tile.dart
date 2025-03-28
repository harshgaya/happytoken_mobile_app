import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettlementTile extends StatelessWidget {
  final String paidAtDate;
  final String totalTransactions;
  final String paidForDate;
  final String amountPaid;
  const SettlementTile(
      {super.key,
      required this.paidAtDate,
      required this.totalTransactions,
      required this.paidForDate,
      required this.amountPaid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Paid',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      paidAtDate,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹$amountPaid',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: Get.width,
              height: 1,
              color: const Color(0xFF858593),
            ),
            const SizedBox(
              height: 5,
            ),
            Text.rich(
              TextSpan(
                  text: 'Paid for ',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: '$totalTransactions successful ',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: 'transactions for $paidForDate',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
