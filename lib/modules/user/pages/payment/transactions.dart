import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/user/controller/user_controller.dart';
import 'package:happy_tokens/modules/user/pages/payment/transaction_details.dart';
import 'package:happy_tokens/modules/user/pages/payment/widgets/transaction_tile.dart';

class Transactions extends StatefulWidget {
  final bool autoSelectFirst;
  const Transactions({super.key, this.autoSelectFirst = false});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final userController = Get.put(UserController());
  final scrollController = ScrollController();

  @override
  void initState() {
    userController.transactionPage = 0;
    userController.transactions.value = [];
    userController.getTransactions().then((value) => {
          if (widget.autoSelectFirst && userController.transactions.isNotEmpty)
            {
              Get.to(() => TransactionDetails(
                  transactionData: userController.transactions[0]))
            }
        });
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        userController.getTransactions();
      }
    });
    super.initState();
  }

  Future<void> _refresh() async {
    userController.transactionPage = 0;
    userController.transactions.value = [];
    await userController.getTransactions();
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
            if (userController.transactions.isEmpty &&
                userController.loadingTransaction.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Show "No Transactions Found!" if the list is empty and not loading
            if (userController.transactions.isEmpty) {
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
                    itemCount: userController.transactions.length,
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = userController.transactions[index];
                      return TransactionTile(
                        transactionData: item,
                      );
                    },
                  ),
                ),
                // Show loading indicator at the bottom while loading more transactions
                if (userController.loadingTransaction.value)
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
