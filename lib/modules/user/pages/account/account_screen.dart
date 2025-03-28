import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/authentication/authentication_controller.dart';
import 'package:happy_tokens/modules/user/pages/account/about_screen.dart';
import 'package:happy_tokens/modules/user/pages/account/notifications.dart';
import 'package:happy_tokens/modules/user/pages/account/privacy_policy.dart';
import 'package:happy_tokens/modules/user/pages/account/terms_condition.dart';
import 'package:happy_tokens/modules/user/pages/payment/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
    getUserName();
    userController.getUserDetails();
    super.initState();
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
                      Obx(() => Text(
                            '₹${userController.walletBalance.value.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ))
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
                  function: () {
                    Get.to(() => const Transactions());
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'Notifications',
                  iconPath: 'assets/icons/account/notification.png',
                  function: () {
                    Get.to(() => NotificationsPage());
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'About',
                  iconPath: 'assets/icons/account/about.png',
                  function: () {
                    Get.to(() => AboutPage());
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'Privacy Policy',
                  iconPath: 'assets/icons/account/privacy.png',
                  function: () {
                    Get.to(() => PrivacyPolicyPage());
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'Terms / Conditions',
                  iconPath: 'assets/icons/account/terms.png',
                  function: () {
                    Get.to(() => TermsAndConditionsPage());
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'Feedback',
                  iconPath: 'assets/icons/account/feedback.png',
                  function: () async {
                    final uri = Uri(
                      scheme: 'mailto',
                      path: userController.helpEmail.value,
                      query:
                          'subject=I want to give feedback&body=Hello, Happy Tokens!', // Add subject and body (optional)
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      print('Could not launch $uri');
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'Logout',
                  iconPath: 'assets/icons/account/logout.png',
                  function: () async {
                    showBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(8),
                            color: const Color(0xFF15181F),
                            height: 330,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      )),
                                ),
                                Image.asset(
                                  'assets/icons/account/logout-b.png',
                                  height: 50,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'Are you sure you want to log out?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'You will be asked to log in again to view and to pay your favourites shops.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8D99B5),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF0047D7),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              )),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await authController.logout();
                                          },
                                          child: const Text(
                                            'Log Out',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Color(0xFF8D98B4)),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                AccountTextIconButtonTile(
                  title: 'Delete Account',
                  iconPath: 'assets/icons/account/delete.png',
                  function: () {
                    showBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(8),
                            color: const Color(0xFF15181F),
                            height: 330,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      )),
                                ),
                                Image.asset(
                                  'assets/icons/account/delete_white.png',
                                  height: 50,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'Are you sure you want to delete your account?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Your account will be deleted. You will need to create a new account to continue using our services.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8D99B5),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF0047D7),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              )),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await authController
                                                .deleteAccount();
                                          },
                                          child: const Text(
                                            'Delete Account',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Color(0xFF8D98B4)),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
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
