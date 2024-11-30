import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../helpers/colors.dart';
import '../../../helpers/utils.dart';
import '../../../widgets/button_no_radius.dart';
import '../authentication_controller.dart';

class UserDetails extends StatefulWidget {
  final String mobile;
  const UserDetails({super.key, required this.mobile});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  bool buttonActive = false;
  final nameController = TextEditingController();
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
              'assets/icons/onboard/signup.jpg',
              height: 400,
              width: 400,
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
                    'Almost Done!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text.rich(
                    TextSpan(
                        text: 'Enter your name below to create \nan account',
                        children: [
                          TextSpan(
                            text: " +91${widget.mobile}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ]),
                    style: const TextStyle(
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
                  controller: nameController,
                  maxLength: 10,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        buttonActive = false;
                      });
                    } else {
                      setState(() {
                        buttonActive = true;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    counter: SizedBox(),
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Enter your name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
      bottomSheet: Obx(() => authController.addingName.value
          ? Utils.showLoader()
          : Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: ButtonNoRadius(
                function: () async {
                  await authController.addName(
                      name: nameController.text, context: context);
                },
                text: 'Sign Up Now',
                active: buttonActive,
              ),
            )),
    );
  }
}
