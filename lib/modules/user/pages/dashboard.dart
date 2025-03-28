import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/colors.dart';
import 'package:happy_tokens/modules/user/pages/account/account_screen.dart';
import 'package:happy_tokens/modules/user/pages/help/help.dart';
import 'package:happy_tokens/modules/user/pages/home/home_screen.dart';
import 'package:happy_tokens/modules/user/pages/home/pay_bill.dart';
import 'package:happy_tokens/modules/user/pages/payment/transactions.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: HomeScreen(),
          item: ItemConfig(
            activeForegroundColor: const Color(AppColors.appMainColor),
            inactiveBackgroundColor: Colors.white,
            icon: const Icon(CupertinoIcons.home),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: Transactions(),
          item: ItemConfig(
            activeForegroundColor: const Color(AppColors.appMainColor),
            inactiveBackgroundColor: Colors.white,
            icon: const Icon(Icons.currency_rupee),
            title: "Transactions",
          ),
        ),
        PersistentTabConfig(
          screen: const PayBill(),
          item: ItemConfig(
            activeForegroundColor: Colors.white,
            inactiveBackgroundColor: Colors.white,
            icon: Image.asset('assets/icons/dashboard/payBill.png'),
            title: "  ",
          ),
        ),
        PersistentTabConfig(
          screen: HelpScreen(),
          item: ItemConfig(
            activeForegroundColor: const Color(AppColors.appMainColor),
            inactiveBackgroundColor: Colors.white,
            icon: const Icon(Icons.help_outline),
            title: "Help",
          ),
        ),
        PersistentTabConfig(
          screen: AccountScreen(),
          item: ItemConfig(
            activeForegroundColor: const Color(AppColors.appMainColor),
            inactiveBackgroundColor: Colors.white,
            icon: const Icon(Icons.person),
            title: "Account",
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Exit App?"),
              content: const Text("Are you sure you want to exit?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Exit"),
                ),
              ],
            ),
          );
          if (shouldExit ?? false) {
            SystemNavigator.pop();
          }
        },
        child: PersistentTabView(
          tabs: _tabs(),
          navBarBuilder: (navBarConfig) => Style13BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
          ),
          navBarOverlap: NavBarOverlap.full(),
        ),
      );
}
