import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/user/controller/user_controller.dart';
import 'package:happy_tokens/modules/user/widgets/refer/wallet_transaction_tile.dart';

class WalletTransactions extends StatefulWidget {
  const WalletTransactions({super.key});

  @override
  State<WalletTransactions> createState() => _WalletTransactionsState();
}

class _WalletTransactionsState extends State<WalletTransactions> {
  final userController = Get.put(UserController());
  final scrollController = ScrollController();

  @override
  void initState() {
    userController.walletTransactionPage = 0;
    userController.walletTransactions.value = [];
    userController.getWalletTransactions().then((value) => {});
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        userController.getWalletTransactions();
      }
    });
    super.initState();
  }

  Future<void> _refresh() async {
    userController.walletTransactionPage = 0;
    userController.walletTransactions.value = [];
    await userController.getWalletTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Transactions'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            // Show loader if transactions are empty and still loading
            if (userController.walletTransactions.isEmpty &&
                userController.loadingWalletTransaction.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Show "No Transactions Found!" if the list is empty and not loading
            if (userController.walletTransactions.isEmpty) {
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
                      'No Wallet Transactions Found!',
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

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: userController.walletTransactions.length,
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = userController.walletTransactions[index];
                      return WalletTransactionTile(
                        walletTransactionData: item,
                      );
                    },
                  ),
                ),
                // Show loading indicator at the bottom while loading more transactions
                if (userController.loadingWalletTransaction.value)
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
