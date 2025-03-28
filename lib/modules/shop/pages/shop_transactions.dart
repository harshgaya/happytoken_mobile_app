import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/shop/controller/shop_controller.dart';
import 'package:happy_tokens/modules/shop/widgets/shop_transaction_tile.dart';
import 'package:happy_tokens/modules/user/controller/user_controller.dart';
import 'package:happy_tokens/modules/user/pages/payment/transaction_details.dart';
import 'package:happy_tokens/modules/user/pages/payment/widgets/transaction_tile.dart';

class ShopTransactions extends StatefulWidget {
  final bool autoSelectFirst;
  const ShopTransactions({super.key, this.autoSelectFirst = false});

  @override
  State<ShopTransactions> createState() => _ShopTransactionsState();
}

class _ShopTransactionsState extends State<ShopTransactions> {
  final shopController = Get.put(ShopController());
  final scrollController = ScrollController();

  @override
  void initState() {
    shopController.transactionPage = 0;
    shopController.transactions.value = [];
    shopController.getTransactions().then((value) => {
          if (widget.autoSelectFirst && shopController.transactions.isNotEmpty)
            {
              Get.to(() => TransactionDetails(
                  transactionData: shopController.transactions[0]))
            }
        });
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        shopController.getTransactions();
      }
    });
    super.initState();
  }

  Future<void> _refresh() async {
    shopController.transactionPage = 0;
    shopController.transactions.value = [];
    await shopController.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            // Show loader if transactions are empty and still loading
            if (shopController.transactions.isEmpty &&
                shopController.loadingTransaction.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Show "No Transactions Found!" if the list is empty and not loading
            if (shopController.transactions.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/payment/empty-transactions.png',
                      height: 200,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'No Transactions Found!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _refresh();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: Color(0xFF4A90E2),
                          ),
                          Text(
                            'Refresh',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xFF4A90E2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Show the transactions list with infinite scrolling
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: shopController.transactions.length,
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = shopController.transactions[index];
                      return ShopTransactionTile(
                        transactionData: item,
                      );
                    },
                  ),
                ),
                // Show loading indicator at the bottom while loading more transactions
                if (shopController.loadingTransaction.value)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            );
          }),
        ),
      ),
    );
  }
}
