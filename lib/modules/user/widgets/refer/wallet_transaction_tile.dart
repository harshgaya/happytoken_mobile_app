import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/user/models/wallet_trans_model.dart';

import '../../../../helpers/utils.dart';

class WalletTransactionTile extends StatelessWidget {
  final WalletTransactionData walletTransactionData;
  const WalletTransactionTile({super.key, required this.walletTransactionData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            walletTransactionData.paidToShop == true
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color: walletTransactionData.paidToShop == true
                ? Colors.red
                : Colors.green,
          ),
          title: Text(
            Utils.timeToIst(timestamp: walletTransactionData.date),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          subtitle: Text(walletTransactionData.message ?? ''),
          trailing: Text(
            '₹${walletTransactionData.amount}',
            style: TextStyle(
              color: walletTransactionData.paidToShop == true
                  ? Colors.red
                  : Colors.green,
              fontSize: 18,
            ),
          ),
        ),
        Container(
          height: 1,
          width: Get.width,
          color: Colors.grey,
        )
      ],
    );
  }
}
