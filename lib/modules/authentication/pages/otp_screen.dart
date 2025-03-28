import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:pinput/pinput.dart';

import '../../../helpers/colors.dart';
import '../../../widgets/button_no_radius.dart';
import 'package:get/get.dart';

import '../authentication_controller.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  final String name;

  const OtpScreen({
    super.key,
    required this.mobileNumber,
    required this.name,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool buttonActive = false;
  final mobileNumberController = TextEditingController();
  final authController = Get.put(AuthenticationController());
  String? otp;
  final _key1 = GlobalKey<State<StatefulWidget>>();

  Future<void> ensureVisibleOnTextArea(
      {required GlobalKey textfieldKey}) async {
    final keyContext = textfieldKey.currentContext;
    if (keyContext != null) {
      await Future.delayed(const Duration(milliseconds: 500)).then(
        (value) => Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController.start.value = 20;
    authController.startTimer();
  }

  @override
  void dispose() {
    authController.timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Back',
                    style: TextStyle(
                      fontSize: 14,
                    )),
              ],
            ),
          ),
        ),
        body: Obx(() => SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/onboard/otp.jpg',
                    height: 300,
                    width: 300,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Welcome',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          (widget.name != null && widget.name!.isNotEmpty)
                              ? widget.name![0].toUpperCase() +
                                  widget.name!.substring(1)
                              : "Unknown",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(AppColors.appMainColor),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black26,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                              text:
                                  "Please enter the OTP sent on your mobile phone number",
                              children: [
                                TextSpan(
                                  text: " +91${widget.mobileNumber}",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: " to login.",
                                ),
                              ]),
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
                      child: Pinput(
                        key: _key1,
                        onTap: () {
                          ensureVisibleOnTextArea(textfieldKey: _key1);
                        },
                        length: 6,
                        defaultPinTheme: PinTheme(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(AppColors.buttonInactiveColor),
                          ),
                        ),
                        onChanged: (value) {
                          otp = value;
                          if (value.isEmpty || value.length < 6) {
                            setState(() {
                              buttonActive = false;
                            });
                          } else {
                            setState(() {
                              buttonActive = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (authController.start.value == 0)
                    InkWell(
                      onTap: () async {
                        authController.start.value = 20;
                        authController.startTimer();
                        await authController.sendOtp(
                            mobile: widget.mobileNumber, context: context);
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "i didn't receive a code  ",
                            ),
                            Text(
                              'Resend',
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (authController.start.value != 0)
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Resend in ',
                          ),
                          Text(
                            '00:${authController.start.value.toString()}s',
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            )),
        bottomSheet: Obx(
          () => authController.otpVerifying.value
              ? Utils.showLoader()
              : Padding(
                  padding: const EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: ButtonNoRadius(
                    function: () async {
                      await authController.verifyOtp(
                        otp: otp!,
                        context: context,
                        mobile: widget.mobileNumber,
                      );
                    },
                    text: 'Verify OTP',
                    active: buttonActive,
                  ),
                ),
        ));
  }
}
