import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:happy_tokens/helpers/colors.dart';
import 'package:happy_tokens/modules/authentication/pages/user_state.dart';

import '../authentication_controller.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final authController = Get.put(AuthenticationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        finishButtonText: 'Login',
        onFinish: () async {
          await authController.saveSharedPrefOnboard();
          Get.offAll(() => const UserState());
        },
        finishButtonStyle: const FinishButtonStyle(
          backgroundColor: Color(AppColors.appMainColor),
        ),
        skipTextButton: const Text(
          'Skip',
          style: TextStyle(
            fontSize: 16,
            color: Color(AppColors.appMainColor),
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
            color: Color(AppColors.appMainColor),
            fontWeight: FontWeight.w600,
          ),
        ),
        trailingFunction: () async {
          await authController.saveSharedPrefOnboard();
          Get.offAll(() => const UserState());
        },
        controllerColor: const Color(AppColors.appMainColor),
        totalPage: 3,
        headerBackgroundColor: Colors.white,
        pageBackgroundColor: Colors.white,
        background: [
          Image.asset(
            'assets/icons/onboard/image1.jpg',
            height: 400,
            width: 400,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
          Image.asset(
            'assets/icons/onboard/image2.jpg',
            height: 400,
            width: 400,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
          Image.asset(
            'assets/icons/onboard/image3.jpg',
            height: 400,
            width: 400,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
        ],
        speed: 1,
        pageBodies: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text(
                  'Guarantee Cashback',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Pay at any restaurant and enjoy up to 50% cashback on your bill! Don't miss out!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text(
                  'Always save guaranteed 25% to 50%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Save 25% to 50% guaranteed on every restaurant payment!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text(
                  'Start now!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Enjoy instant savings on your meals every time you dine out.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
