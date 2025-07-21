import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class StackTile extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  final String text6;
  final String text7;
  final String text8;
  final String text9;
  final Widget? widget;
  final String? totalAmountWithDiscount;
  const StackTile(
      {super.key,
      required this.text1,
      required this.text2,
      required this.text3,
      required this.text4,
      required this.text5,
      required this.text6,
      required this.text7,
      required this.text8,
      required this.text9,
      this.widget,
      this.totalAmountWithDiscount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: Get.width - 30,
      height: 220,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFE4FFFA),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            text1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            text2,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF00569E),
              fontSize: 32,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text3,
                style: const TextStyle(
                  color: Color(0xFF6B6B6B),
                  fontSize: 14,
                ),
              ),
              if (widget != null) widget!,
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          // const Text(
          //   'Total Amount With Discount',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16,
          //   ),
          // ),
          // Text(
          //   totalAmountWithDiscount ?? '0',
          //   style: const TextStyle(
          //     fontWeight: FontWeight.bold,
          //     color: Color(0xFF00569E),
          //     fontSize: 32,
          //   ),
          // ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    text4,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    text5,
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    text6,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    text7,
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    text8,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    text9,
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
