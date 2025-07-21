import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final String amountToPay;
  final String radioValue;

  final Function(String val) function;
  final String groupValue;
  final String lastText;
  final String walletBalance;
  final bool showWalletBalance;

  const PaymentMethodTile({
    super.key,
    required this.function,
    required this.groupValue,
    required this.title,
    required this.amountToPay,
    required this.lastText,
    required this.walletBalance,
    required this.showWalletBalance,
    required this.radioValue,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = radioValue == groupValue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: InkWell(
        onTap: () => function(radioValue),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: Get.width - 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color:
                    !isSelected ? const Color(0xFFFB5016) : Colors.transparent),
            color: isSelected
                ? const Color(0xFFFB5016).withOpacity(0.2)
                : const Color(0xFFFB5016).withOpacity(0),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 3,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: radioValue,
                    groupValue: groupValue,
                    onChanged: (value) {
                      if (value != null) {
                        function(value);
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text.rich(
                          TextSpan(
                            text: 'Amount To Pay : ',
                            style: const TextStyle(fontSize: 14),
                            children: [
                              TextSpan(
                                text: '₹$amountToPay',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lastText,
                          maxLines: null,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              if (showWalletBalance)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Color(0xFFFB5016),
                        ),
                        child: Text.rich(
                          TextSpan(
                            text: 'Wallet Balance : ',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: '₹$walletBalance',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
