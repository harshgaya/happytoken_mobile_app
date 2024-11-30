import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/authentication/authentication_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/sharedprefs.dart';
import '../../controller/user_controller.dart';
import '../../widgets/account/account_text_icon_button_tile.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final userController = Get.put(UserController());
  final authController = Get.put(AuthenticationController());
  String? name;
  String? mobileNumber;

  getUserName() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    name = sharedPreferences.getString(SharedPreferenceKey.name);
    mobileNumber = sharedPreferences.getString(SharedPreferenceKey.mobile);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 250,
                width: Get.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFFE7E00),
                      Color(0xFFF94714),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      name ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '+91$mobileNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 250 - 60,
                left: (Get.width / 2) - 90,
                child: Container(
                  width: 180,
                  height: 120,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.yellow,
                          size: 20,
                        ),
                      ),
                      const Text(
                        'Wallet Balance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '₹200',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                AccountTextIconButtonTile(
                  title: 'Transactions',
                  iconPath: 'assets/icons/account/transaction.png',
                  function: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'Notifications',
                  iconPath: 'assets/icons/account/notification.png',
                  function: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'About',
                  iconPath: 'assets/icons/account/about.png',
                  function: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'Privacy Policy',
                  iconPath: 'assets/icons/account/privacy.png',
                  function: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'Terms / Conditions',
                  iconPath: 'assets/icons/account/terms.png',
                  function: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'Feedback',
                  iconPath: 'assets/icons/account/feedback.png',
                  function: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'Logout',
                  iconPath: 'assets/icons/account/logout.png',
                  function: () async {
                    await authController.logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
