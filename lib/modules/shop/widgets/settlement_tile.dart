import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/colors.dart';

class SettlementTile extends StatelessWidget {
  final String paidAtDate;
  final String totalTransactions;
  final String paidForDate;
  final String amountPaid;
  final String totalDiscount;
  final String platformFee;
  final String transactionNumber;
  const SettlementTile(
      {super.key,
      required this.paidAtDate,
      required this.totalTransactions,
      required this.paidForDate,
      required this.amountPaid,
      required this.totalDiscount,
      required this.platformFee,
      required this.transactionNumber});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                width: Get.width,
                height: 400,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Paid For Date',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(paidForDate),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Bill Amount',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                              '₹${double.parse(amountPaid) + double.parse(platformFee) + double.parse(totalDiscount)}'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Discount & Cashback',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text('₹$totalDiscount'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Platform Fee',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text('₹$platformFee'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Paid Amount',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text('₹$amountPaid'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bank Transaction Ref. No.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(transactionNumber),
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const Text(
                'View Details',
                style: TextStyle(
                    fontSize: 12, color: Color(AppColors.appMainColor)),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       'Total Discount',
              //       style: TextStyle(
              //         fontSize: 12,
              //       ),
              //     ),
              //     Text(
              //       '₹$totalDiscount',
              //       style: const TextStyle(
              //         fontSize: 12,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       'Platform Fee',
              //       style: TextStyle(
              //         fontSize: 12,
              //       ),
              //     ),
              //     Text(
              //       '₹$platformFee',
              //       style: const TextStyle(
              //         fontSize: 12,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
