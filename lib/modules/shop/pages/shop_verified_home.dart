import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/authentication/authentication_controller.dart';
import 'package:happy_tokens/modules/shop/controller/shop_controller.dart';
import 'package:happy_tokens/modules/shop/pages/settlement.dart';
import 'package:happy_tokens/modules/shop/pages/shop_homepage.dart';
import 'package:happy_tokens/modules/shop/pages/shop_transactions.dart';
import 'package:happy_tokens/modules/shop/widgets/stack_tile.dart';
import 'package:happy_tokens/modules/user/pages/help/help.dart';
import 'package:shimmer/shimmer.dart';

import '../../user/controller/user_controller.dart';

class ShopVerifiedHome extends StatefulWidget {
  const ShopVerifiedHome({super.key});

  @override
  State<ShopVerifiedHome> createState() => _ShopVerifiedHomeState();
}

class _ShopVerifiedHomeState extends State<ShopVerifiedHome> {
  final authController = Get.put(AuthenticationController());
  final userController = Get.put(UserController());
  final shopController = Get.put(ShopController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopController.checkShopStatus();
  }

  int _currentIndex = 0;

  final List<Widget> _screens = [
    ShopHomePage(),
    ShopTransactions(),
    Settlement(),
    HelpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
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

        // Only pop the page if the user confirms exit (shouldExit == true)
        if (shouldExit ?? false) {
          Navigator.of(context).pop();
        }
      },
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.black54,
            unselectedLabelStyle: const TextStyle(
              color: Colors.black54,
            ),
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Transactions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.currency_rupee),
                label: 'Settlements',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.help),
                label: 'Help',
              ),
            ],
          ),
          body: _screens[_currentIndex],
        ),
      ),
    );
  }
}
