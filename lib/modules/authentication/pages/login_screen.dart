import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/colors.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/authentication/authentication_controller.dart';
import 'package:happy_tokens/modules/authentication/pages/otp_screen.dart';
import 'package:happy_tokens/modules/authentication/pages/shop_login_screen.dart';
import 'package:happy_tokens/widgets/button_no_radius.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool buttonActive = false;
  final mobileNumberController = TextEditingController();
  final authController = Get.put(AuthenticationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/icons/onboard/login.jpg',
              height: 400,
              width: 400,
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Enter your mobile number',
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
                    "Mobile number helps us to reach you for your booking and for awesome offers",
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
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: mobileNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (value.isEmpty || value.length < 10) {
                      setState(() {
                        buttonActive = false;
                      });
                    } else if (value.length == 10) {
                      setState(() {
                        buttonActive = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    counter: const SizedBox(),
                    filled: true,
                    fillColor: const Color(AppColors.buttonInactiveColor),
                    hintText: 'Enter your mobile number',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        width: 60,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/onboard/india.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text('+91')
                          ],
                        ),
                      ),
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                      fontSize: 14,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.offAll(() => const ShopLoginScreen());
              },
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '  Shop Login>>',
                  style: TextStyle(
                      color: Color(
                    AppColors.appMainColor,
                  )),
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
      bottomSheet: Obx(() => authController.otpSending.value
          ? Utils.showLoader()
          : Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: ButtonNoRadius(
                function: () async {
                  await authController.sendOtp(
                      mobile: mobileNumberController.text, context: context);
                },
                text: 'Get OTP',
                active: buttonActive,
              ),
            )),
    );
  }
}
